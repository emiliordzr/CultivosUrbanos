//
//  RegistrationView.swift
//  CultivosUrbanos
//
//  Created by iOS Lab on 11/04/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Logo placeholder
            Rectangle()
                .frame(width: 100, height: 100)
                .border(Color.black, width: 1)

            Text("Regístrate")
                .font(.largeTitle)
                .padding()

            // Full name text field
            TextField("Nombre Completo", text: $fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Email text field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password text field
            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Register button
            Button(action: {
                // Handle register action
            }) {
                Text("Regístrate")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()

            // Already have account button
            HStack {
                Text("Ya tienes cuenta?")
                Button("Inicia sesión") {
                    // Handle switch to login action
                }
                .foregroundColor(.blue)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
