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
    @State var isReniewRequested : Bool = false
    @State var isDeleteRequested : Bool = false
    @State var selectedLicence : Licence?
    
    init(client: Client) {
        let predicate = NSPredicate(format: "client == %@",argumentArray: [client])
        _licences = FetchRequest(entity: Licence.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: true)], predicate: predicate)
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
                        Button(action: {
                            selectedLicence = l
                            isReniewRequested.toggle()
                        }){
                            Image(systemName: "arrow.uturn.forward.square.fill")
                                .font(.title)
                        }
                        Spacer()
                        Button(action: {
                            selectedLicence = l
                            isDeleteRequested.toggle()
                        }){
                            Image(systemName: "trash.square.fill")
                                .font(.title)
                        }
                        Spacer()
                        Button(action: {
                            selectedLicence = l
                            isDeleteRequested.toggle()
                        }){
                            Image(systemName: "trash.square.fill")
                        }
                        /*NavigationLink(destination: LicenceDetail(licence: l)){
                            Image(systemName: "info.square.fill")
                        }.font(.title)*/
                    }
                }.width(100)
            }
        }
        .confirmationDialog("Êtes-vous sûr de renouveller cette licence?", isPresented: $isReniewRequested){
            Button("Confirmer", action: reniewLicence)
        }
        .confirmationDialog("Êtes-vous sûr de supprimer cette licence?", isPresented: $isDeleteRequested){
            Button("Supprimer", role: .destructive , action: deleteLicence)
        }
    }
    
    
    private func deleteLicence(){
        do {
            viewContext.delete(selectedLicence!)
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
        
    private func reniewLicence(){
        do {
            selectedLicence!.reniew()
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("error")
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
