//
//  ClientInfoEdit.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct ClientInfoEdit: View {
    var client : Client
    @State private var isEditionMode : Bool = false
    
    var body: some View {
        if(!isEditionMode){
            HStack {
                ClientInformations(client: client)
                Spacer()
                Button(action: {isEditionMode.toggle()}){
                    Label("Editer", systemImage: "pencil")
                }.controlSize(.large)
            }.padding(.horizontal,20)
        } else{
            ClientEditView(
                isEditionMode: $isEditionMode,
                name: client.name!,
                email: client.email!,
                id: client.id!,
                profilePicture: client.profilePicture
            )
        }
    }
}

struct ClientInfoEdit_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context:viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        return ClientInfoEdit(client : c)
    }
}
