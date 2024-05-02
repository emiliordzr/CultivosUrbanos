import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol AuthenticationFormProtocol {
    var formisValid: Bool { get }
}

struct Plant: Codable, Identifiable {
    let id: String
    let name: String
    let countryOfOrigin: String
    let additionalInfo: String
    let plantType: String
}

enum PlantError: Error {
    case userNotFound
    case plantCreationFailed(String)
    case plantTypeNotFound
}

enum PlantState: String, Codable {
    case good, caution, critical
    var description: String {
        switch self {
        case .good:
            return "Good"
        case .caution:
            return "Caution"
        case .critical:
            return "Critical"
        }
    }
}

struct SensorRange: Codable {
    var min: Double
    var max: Double
}

struct PlantSensorRanges: Codable {
    var luminosity: SensorRange
    var pHLevels: SensorRange
    var soilMoisture: SensorRange
    var temperature: SensorRange
    
    enum CodingKeys: String, CodingKey {
        case luminosity
        case pHLevels
        case soilMoisture
        case temperature
    }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var hasPlants = false
    @Published var creationSuccessful = false
    @Published var plants: [Plant] = []

    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: fallo al iniciar sesion, error \(error.localizedDescription)")
        }
    }
    
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("usuarios").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: fallo al crear un usuario \(error.localizedDescription)")
            
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut() //Signs out user in backend
            self.userSession = nil //wipes out user session
            self.currentUser = nil //wipes current user data model
        } catch {
            print("DEBUG: fallo al salir de la sesión, error \(error.localizedDescription)")
        }
        
    }
    
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("usuarios").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUD: Usuario activo es \(self.currentUser)")
    }
    
    // Function to fetch all plants for the current user
    func fetchUserPlants() async {
        guard let user = currentUser else { return }
        
        let db = Firestore.firestore()
        let plantsRef = db.collection("usuarios").document(user.id).collection("plantas")
        
        do {
            let snapshot = try await plantsRef.getDocuments()
            self.plants = snapshot.documents.compactMap { document -> Plant? in
                try? document.data(as: Plant.self)
            }
            self.hasPlants = !self.plants.isEmpty
        } catch {
            print("Error fetching plants: \(error)")
            self.plants = [] // Clear the array if there is an error
            self.hasPlants = false
        }
    }
    
    
    func createPlant(id: String, name: String, countryOfOrigin: String, additionalInfo: String, plantType: String) async throws {
        guard let user = self.currentUser else { throw PlantError.userNotFound }
        
        // Fetch the document ID for the specified plantType
        let db = Firestore.firestore()
        let plantTypeRef = db.collection("plant_type").whereField("name", isEqualTo: plantType).limit(to: 1)
        
        let documents = try await plantTypeRef.getDocuments()
        guard let document = documents.documents.first else {
            throw PlantError.plantTypeNotFound
        }
        
        let plantTypeID = document.documentID
        
        // Create a new plant object
        let newPlant = Plant(
            id: id,
            name: name,
            countryOfOrigin: countryOfOrigin,
            additionalInfo: additionalInfo,
            plantType: plantTypeID
        )
        
        // Store the plant under the specific plant type
        let cropsRef = db.collection("plant_type").document(plantTypeID).collection("crops")
        do {
            let newPlantData = try Firestore.Encoder().encode(newPlant)
            let documentRef = try await cropsRef.addDocument(data: newPlantData)
            
            // Then link this new plant under the user's plant collection
            let userPlantRef = db.collection("usuarios").document(user.id).collection("plantas")
            try await userPlantRef.addDocument(data: [
                "nombre_planta": name,
                "tipoPlanta": plantTypeID,  // Store the plant type ID
                "documentRef": documentRef.documentID  // Store the reference to the crop document
            ])
            self.hasPlants = true // Optionally update local state to indicate the user has plants
        } catch {
            print("Error creating plant: \(error)")
            throw error
        }
    }
}

extension AuthViewModel {
    func fetchSensorRanges(plantType: String, completion: @escaping (Result<PlantSensorRanges, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("plant_type").document(plantType).getDocument { document, error in
            guard let document = document, document.exists else {
                completion(.failure(error ?? NSError(domain: "FetchError", code: -1, userInfo: nil)))
                return
            }
            do {
                let ranges = try document.data(as: PlantSensorRanges.self)
                completion(.success(ranges))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func evaluatePlantState(with currentReadings: PlantSensorRanges, against ranges: PlantSensorRanges) -> PlantState {
        var cautionCount = 0

        // Luminosity evaluation
        if currentReadings.luminosity.min < ranges.luminosity.min || currentReadings.luminosity.max > ranges.luminosity.max {
            cautionCount += 1
        }

        // pH level evaluation
        if currentReadings.pHLevels.min < ranges.pHLevels.min || currentReadings.pHLevels.max > ranges.pHLevels.max {
            cautionCount += 1
        }

        // Soil moisture evaluation
        if currentReadings.soilMoisture.min < ranges.soilMoisture.min || currentReadings.soilMoisture.max > ranges.soilMoisture.max {
            cautionCount += 1
        }

        // Temperature evaluation
        if currentReadings.temperature.min < ranges.temperature.min || currentReadings.temperature.max > ranges.temperature.max {
            cautionCount += 1
        }

        // Determine the plant state based on the number of cautions
        switch cautionCount {
        case 0:
            return .good
        case 1...2:
            return .caution
        default:
            return .critical
        }
    }
}

