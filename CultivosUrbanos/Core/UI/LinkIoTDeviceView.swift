import SwiftUI

struct LinkIoTDeviceView: View {
    //@State private var isMenuVisible: Bool = false
    
    var body: some View {
        NavigationView {
            // Using GeometryReader to fill the entire screen
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Main content view
                    VStack {
                        CustomNavigationBar(title: "MI CULTIVO")
                            .font(.title2)
                            .foregroundColor(Color.colorText)
                            .padding()
                        Spacer()
                        Text("Empieza a cuidar tu cultivo vinculando el dispositivo IoT a tu aplicación")
                            .font(.headline)
                            .foregroundColor(Color.azulClaro)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        NavigationLink(destination: AddPlantView()) {
                            Text("VINCULAR")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.verdeclaro)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Text("No sabes como vincular el dispositivo con tu aplicación?")
                            .font(.subheadline)
                            .foregroundColor(Color.colorText)
                        
                        NavigationLink(destination: TutorialView()) {
                            Text("TUTORIAL")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.grisClaro)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)                  
                }
            }
            .navigationBarHidden(true)
        }
    }
}
struct LinkIoTDevice_Previews: PreviewProvider {
    static var previews: some View {
        LinkIoTDeviceView()
    }
}
