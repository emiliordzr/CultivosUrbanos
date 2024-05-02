import SwiftUI

struct AddPlantView: View {
    @State private var id = ""
    @State private var nombre_planta = ""
    @State private var pais_origen = ""
    @State private var info_adicional = ""
    @State private var tipo_planta = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let plantTypes = ["Leguminosas", "Hierbas", "Hortalizas de fruto", "Tubérculos", "Verduras de hojas verdes"]
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "MI CULTIVO")
            Form {
                Section {
                    TextField("Nombre de la planta", text: $nombre_planta)
                    Picker("Tipo de planta", selection: $tipo_planta) {
                        ForEach(plantTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    TextField("País de origen", text: $pais_origen)
                    TextField("Información adicional", text: $info_adicional)
                }
            }
            
            Button("Añadir planta") {
                Task {
                    do {
                        try await viewModel.createPlant(
                            id: id,
                            name: nombre_planta,
                            countryOfOrigin: pais_origen,
                            additionalInfo: info_adicional,
                            plantType: tipo_planta
                        )
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // Handle errors appropriately
                        print("Error al crear la planta: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!formisValid)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AddPlantView: AuthenticationFormProtocol {
    var formisValid: Bool {
        !nombre_planta.isEmpty && !pais_origen.isEmpty && !tipo_planta.isEmpty
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView().environmentObject(AuthViewModel())
    }
}

