import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack (alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(Color.colorText)
                        }
                    }
                }
                
                Section ("General") {
                    HStack {
                        SettingsRowView(imageName: "gear", title: "Versión", tintColor: Color.colorText)
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(Color.colorText)
                    }
                }
                
                Section ("Cuenta") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Logout", tintColor: Color.verdeobscuro)
                    }
                    
                    Button {
                        print("Cuenta Borrada")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Borrar Cuenta", tintColor: Color.verdeobscuro)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

