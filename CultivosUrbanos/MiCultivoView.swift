//
//  MiCultivoView.swift
//  CultivosUrbanos
//
//  Created by iOS Lab on 11/04/24.
//

import SwiftUI

struct MiCultivoView: View {
    @State private var showSidebar: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                                    Button(action: {
                                        // Toggle sidebar visibility
                                        self.showSidebar.toggle()
                                    }) {
                                        Image(systemName: "line.horizontal.3")
                                            .imageScale(.large)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.leading, 20) // Adjust this padding to align with the sidebar button if necessary

                                    Spacer() // This will push the title to the center
                                    
                                    Text("MI CULTIVO")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding(.leading) // Negative padding to counteract button padding and center the title

                                    Spacer() // This will keep the title centered
                                    
                                    // Invisible placeholder to balance the HStack
                                    Image(systemName: "line.horizontal.3")
                                        .imageScale(.large)
                                        .foregroundColor(.clear)
                                        .padding(.leading, 20)
                                }
                
                
                Text("Cultivo de Aldo")
                    .font(.title)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

                Text("Empieza a cuidar tu cultivo vinculando el dispositivo IoT a tu aplicación")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                Button(action: {
                    // Handle the action to link the IoT device
                }) {
                    Text("VINCULAR")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()

                Text("No sabes como vincular el dispositivo con tu aplicación?")
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    // Handle the action to show tutorial
                }) {
                    Text("TUTORIAL")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MiCultivoView_Previews: PreviewProvider {
    static var previews: some View {
        MiCultivoView()
    }
}
