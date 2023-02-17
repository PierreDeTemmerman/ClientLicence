//
//  ClientInformation.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 10/02/2023.
//

import SwiftUI

struct ClientInformations: View {
    var client : Client
    
    var body: some View {
        HStack(spacing:20){
            if let pp = client.profilePicture{
                ProfilePicture(image: NSImage(data: pp)!)
            }else{
                ProfilePicture(image: NSImage(named: "default")!)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(client.name!)
                    .font(.title2)
                Text(client.email!)
                Text(client.id!.uuidString)
            }
        }
        
    }
}

struct ClientInformations_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context:viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        return ClientInformations(client : c)
    }
}
