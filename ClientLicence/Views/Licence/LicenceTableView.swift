//
//  LicenceTableView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct LicenceTableView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Licence.entity(),
        sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: false)],
        predicate: NSPredicate(format: "endDate >= %@ ", argumentArray: [Date()])
    )
    var licences: FetchedResults<Licence>
    @State var selectedLicence : Licence?
    @State var isShowingLicence : Bool = false
    @State var isReniewRequested : Bool = false
    @State var isDeleteRequested : Bool = false
    
    var body: some View {
            VStack(alignment: .leading){
                Text("Licences")
                    .font(.title2)
                Table(licences.reversed()){
                    TableColumn("Client", value: \.client!.name!)
                    TableColumn("Email", value: \.client!.email!)
                    TableColumn("Logiciel", value: \.software!.name!)
                    TableColumn("Editeur", value: \.software!.editor!.name!)
                    TableColumn("Type de licence", value: \.software!.type!.name!)
                    TableColumn("Date début", value: \.startDateString)
                    TableColumn("Date fin", value: \.endDateString)
                    TableColumn("") { l in
                        HStack{
                            Button(action: {isReniewRequested.toggle()}){
                                Image(systemName: "arrow.uturn.forward.square.fill")
                                    .font(.title)
                            }
                            .confirmationDialog("Êtes-vous sûr de renouveller cette licence?", isPresented: $isReniewRequested){
                                Button("Confirmer", action: {reniewLicence(licence: l)})
                            }
                            Spacer()
                            Button(action: {isDeleteRequested.toggle()}){
                                Image(systemName: "trash.square.fill")
                                    .font(.title)
                            }
                            .confirmationDialog("Êtes-vous sûr de supprimer cette licence?", isPresented: $isDeleteRequested){
                                Button("Supprimer", role: .destructive , action: {deleteLicence(licence: l)})
                            }
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

struct LicenceTableView_Previews: PreviewProvider {
    static var previews: some View {
        LicenceTableView()
    }
}
