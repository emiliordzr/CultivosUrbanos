import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
        }
        //Form fields
        VStack(spacing: 24) {
            InputView(text: $email,
                      title: "Correo",
                      placeholder: "correo@example.com")
            .autocapitalization(.none)
            
            InputView(text: $fullname,
                      title: "Nombre",
                      placeholder: "Jose")
            
            
            InputView(text: $password,
                      title: "Contraseña",
                      placeholder: "Contraseña... ", isSecureField: true)
            
            ZStack {
                InputView(text: $confirmPassword,
                          title: "Confirmar Contraseña",
                          placeholder: "Contraseña... ", isSecureField: true)
                if !password.isEmpty && !confirmPassword.isEmpty {
                    if password == confirmPassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color.verdeclaro)
                    } else {
                        Image(systemName: "xkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                    }
                }
            }
          
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        
        //Sign Up button
        Button {
            Task {
                try await viewModel.createUser(withEmail:email, password: password, fullname:fullname)
            }
        } label: {
            HStack {
                Text("Registrate")
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
        
        Button {
            dismiss()
        } label: {
            HStack (spacing: 3) {
                Text("Ya tienes una cuenta?")
                Text("Inicia Sesión")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
