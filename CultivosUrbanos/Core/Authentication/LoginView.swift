import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                //Image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                //Form fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Correo",
                              placeholder: "correo@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Contraseña",
                              placeholder: "Contraseña... ", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign In button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Inicia Sesión")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.verdeclaro)
                .disabled(!formisValid)
                .opacity(formisValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
    
                Spacer()
                
                
                //Sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                    
                } label: {
                    HStack (spacing: 3) {
                        Text("No tienes una cuenta")
                        Text("Registrate")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}


extension LoginView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

