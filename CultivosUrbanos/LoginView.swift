//
//  LoginView.swift
//  CultivosUrbanos
//
//  Created by iOS Lab on 11/04/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Logo placeholder
            Rectangle()
                .frame(width: 100, height: 100)
                .border(Color.black, width: 1)

            Text("Inicia sesión")
                .font(.largeTitle)
                .padding()

            // Email text field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password text field
            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Login button
            Button(action: {
                // Handle login action
            }) {
                Text("Iniciar sesión")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()

            // Forgot password button
            Button("Olvidaste tu contraseña?") {
                // Handle forgot password action
            }
            .padding()

            Spacer()

            // Register button
            HStack {
                Text("No tienes una cuenta?")
                Button("Registrate") {
                    // Handle register action
                }
                .foregroundColor(.blue)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
