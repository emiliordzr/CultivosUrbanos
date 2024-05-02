import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    var isPickerField: Bool = false
    var pickerOptions: [String]? = nil
    var onPickerSelect: ((String) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color.verdeobscuro)
                .fontWeight(.semibold)
                .font(.footnote)

            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else if isPickerField {
                Menu {
                    if let options = pickerOptions {
                        ForEach(options, id: \.self) { option in
                            Button(option) {
                                text = option
                                onPickerSelect?(option)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(text.isEmpty ? placeholder : text)
                            .foregroundColor(text.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }

            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        // Example for testing the picker functionality
        InputView(
            text: .constant("Leguminosa"), // Initial selected value
            title: "Tipo de planta",
            placeholder: "Selecciona tipo de planta",
            isPickerField: true,
            pickerOptions: ["Leguminosa", "Hortaliza", "Frutal", "Herbácea"], // Options for the picker
            onPickerSelect: { selectedType in
                print("Selected type: \(selectedType)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
