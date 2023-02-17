//
//  ClientLicencesView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct ClientLicencesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var licences: FetchedResults<Licence>
    
    init(client: Client) {
        let predicate = NSPredicate(format: "client == %@",argumentArray: [client])
        _licences = FetchRequest(entity: Licence.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: false)], predicate: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Licences")
                .font(.title2)
            Table(licences){
                TableColumn("Logiciel", value: \.software!.name!)
                TableColumn("Editeur", value: \.software!.editor!.name!)
                TableColumn("Type de licence", value: \.software!.type!.name!)
                TableColumn("Date début", value: \.startDateString)
                TableColumn("Date fin", value: \.endDateString)
                TableColumn("") { l in
                    HStack{
                        Button(action: {reniewLicence(licence: l)}){
                            Image(systemName: "arrow.uturn.forward.square.fill")
                        }.font(.title)
                        Spacer()
                        Button(action: {deleteLicence(licence: l)}){
                            Image(systemName: "trash.square.fill")
                        }.font(.title)
                        Spacer()
                        NavigationLink(destination: LicenceDetail(licence: l)){
                            Image(systemName: "info.square.fill")
                        }.font(.title)
                    }
                }.width(100)
            }
        }
    }
    
    
    private func deleteLicence(licence : Licence){
        do {
            viewContext.delete(licence)
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func reniewLicence(licence : Licence){
        do {
            licence.reniew()
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("error")
            //message = "Impossible de modifier le client, aucun champ ne peut être vide"
        }
    }
}

struct ClientLicencesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context: viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        //c.profilePicture = NSImage(named: "default")?.tiffRepresentation!
        return ClientLicencesView(client: c)
    }
}
