import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    //@Binding var isMenuVisible: Bool
    
    var body: some View {
        HStack {
            /*Button(action: {
                withAnimation {
                    isMenuVisible.toggle()
                }
                //Action for opening menu
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(Color.verdeclaro)

            }*/
            
            Spacer()
            
            Text(title)
                .font(.title)
                .foregroundColor(Color.verdeobscuro)
            
            Spacer() // Keep the title centered
            
            // This empty spacer is used to balance the title in the center
            // Because the menu button is only on the left side
            // If button on the right side, remove the spacer
            Spacer().frame(width: 15)
        }
        .padding()
        .background(Color.white)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    @State static var isMenuVisiblePreview = true
    
    static var previews: some View {
        CustomNavigationBar(title: "MI CULTIVO")
    }
}
