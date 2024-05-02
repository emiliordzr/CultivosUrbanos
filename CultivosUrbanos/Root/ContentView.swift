import SwiftUI
import FirebaseAuth


struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel  // Uses AuthViewModel for all operations
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                // User is logged in, show tab view
                mainTabView
            } else {
                // User is not logged in, show login view without tabs
                LoginView()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUserPlants()
                if viewModel.plants.isEmpty {
                    viewModel.hasPlants = false
                } else {
                    viewModel.hasPlants = true
                }
            }
        }
    }
    
    var mainTabView: some View {
        TabView {
            // Tab for Cultivo or LinkIoTDeviceView based on whether the user has plants
            Group {
                if viewModel.hasPlants {
                    PlantCarouselView()
                } else {
                    LinkIoTDeviceView()
                }
            }
            .tabItem {
                Label("Cultivo", systemImage: "leaf.circle")
            }
            
            // Tab for MisCultivosView
            MisCultivosView()
                .tabItem {
                    Label("Mis Plantas", systemImage: "list.bullet.rectangle")
                }
            
            // Tab for ProfileView
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
