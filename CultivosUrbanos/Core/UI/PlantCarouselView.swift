//  PlantCarouselView.swift
//  CultivosUrbanos
//
//  Created by iOS Lab on 15/04/24.
//

import SwiftUI

struct PlantCarouselView: View {
    @EnvironmentObject var ViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "MI CULTIVO")
            Spacer()
            
            // Assuming authViewModel holds an array or similar structure for plant data
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(ViewModel.plants, id: \.id) { plant in
                        PlantView(plant: plant)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Button for adding more plants
            Button(action: {
                // Action for adding more plants
            }) {
                Text("AÑADIR MÁS PLANTAS")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct PlantView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var plant: Plant
    
    @State private var plantState: PlantState = .good // Default state
    @State private var sensorRanges: PlantSensorRanges?
    
    var body: some View {
        VStack {
            Text(plant.name)
                .font(.headline)
            
            // Image view updated based on the plant state
            Image(plantImage(for: plantState))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text("Estado: \(plantState.description)")
                .padding()
            
            // Display dynamically fetched sensor values if available
            if let ranges = sensorRanges {
                HStack {
                    SensorView(sensorType: "Luminosidad", value: "\(ranges.luminosity.min) - \(ranges.luminosity.max)")
                    SensorView(sensorType: "pH", value: "\(ranges.pHLevels.min) - \(ranges.pHLevels.max)")
                    SensorView(sensorType: "Humedad en la tierra", value: "\(ranges.soilMoisture.min) - \(ranges.soilMoisture.max)")
                    SensorView(sensorType: "Temperatura", value: "\(ranges.temperature.min) - \(ranges.temperature.max)")
                }
            }
        }
        .onAppear {
            fetchSensorData()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
    
    func fetchSensorData() {
        viewModel.fetchSensorRanges(plantType: plant.plantType) { result in
            switch result {
            case .success(let ranges):
                self.sensorRanges = ranges
                // Assuming 'ranges' is the correct set of sensor ranges needed
                // for both 'currentReadings' and 'against' parameters
                self.plantState = viewModel.evaluatePlantState(with: ranges, against: ranges)
            case .failure(let error):
                print("Error fetching sensor ranges: \(error)")
            }
        }
    }

    
    func plantImage(for state: PlantState) -> String {
        switch state {
        case .good:
            return "good"
        case .caution:
            return "okay"
        case .critical:
            return "bad"
        }
    }
   
}

struct SensorView: View {
    var sensorType: String
    var value: String
    
    var body: some View {
        VStack {
            Text(sensorType)
                .font(.caption)
            Text(value)
                .font(.title3)
        }
    }
}

// Create a Preview for the view
struct PlantCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PlantCarouselView()
    }
}
