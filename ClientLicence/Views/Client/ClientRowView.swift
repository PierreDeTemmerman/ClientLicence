//
//  ClientRowView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 14/02/2023.
//

import SwiftUI

struct ClientRowView: View {
    var client : Client
    var body: some View {
        HStack{
            if let pp = client.profilePicture{
                ProfilePicture(image: NSImage(data: pp)!, size: 20)
            }else{
                ProfilePicture(image: NSImage(named: "default")!, size: 20)
            }
            Text(client.name!)
        }
    }
}

struct ClientRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context:viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        c.profilePicture = NSImage(named: "default")?.tiffRepresentation!
        return ClientRowView(client:c)
    }
}
