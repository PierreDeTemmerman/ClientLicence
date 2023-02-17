//
//  ClientDetails.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 10/02/2023.
//

import SwiftUI

struct ClientDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    var client: Client
    @State var isShowingAdd : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ClientInfoEdit(client: client)
                Divider()
                ClientLicencesView(client: client)
                Button(action: {isShowingAdd.toggle()}){
                    Image(systemName: "plus")
                }
            }
        }
        .padding(20)
        .sheet(isPresented: $isShowingAdd){
            LicenceAddToClientView(client: client)
        }
    }
}

struct ClientDetails_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context: viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        //c.profilePicture = NSImage(named: "default")?.tiffRepresentation!
        return ClientDetails(client: c)
    }
}
