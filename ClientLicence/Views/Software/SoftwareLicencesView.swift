//
//  SoftwareLicencesView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct SoftwareLicencesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var licences: FetchedResults<Licence>
    @State var isReniewRequested : Bool = false
    @State var isDeleteRequested : Bool = false
    @State var selectedLicence : Licence?
    
    init(software: Software) {
        let predicate = NSPredicate(format: "software == %@",argumentArray: [software])
        _licences = FetchRequest(entity: Licence.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Licences")
                .font(.title2)
            Table(licences){
                TableColumn("Client", value: \.client!.name!)
                TableColumn("Email", value: \.client!.email!)
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
                        NavigationLink(destination: LicenceDetail(licence: l)){
                            Image(systemName: "info.square.fill")
                        }.font(.title)
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

struct SoftwareLicencesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        
        //Editor
        editor.id = UUID()
        editor.name = "Microsoft"
        //Category
        category.id = UUID()
        category.name = "Traitement de texte"
        //Licence Type
        lt.id = UUID()
        lt.isUnique = false
        lt.name = "Journalier"
        lt.days = 1
        //Software
        software.id = UUID()
        software.name = "Word"
        software.releaseDate = Date()
        software.info="lorem ipsum"
        software.link="word.com"
        software.editor = editor
        software.category = category
        software.type = lt
        return SoftwareLicencesView(software: software)
    }
}
