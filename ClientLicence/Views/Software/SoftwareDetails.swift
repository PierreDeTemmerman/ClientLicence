//
//  SoftwareDetails.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct SoftwareDetails: View {
    var software : Software
    @State var isShowingAdd : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                SoftwareInformation(software: software)
                Divider()
                SoftwareLicencesView(software: software)
                Button(action: {isShowingAdd.toggle()}){
                    Image(systemName: "plus")
                }
            }
        }
        .padding(20)
        .sheet(isPresented: $isShowingAdd){
            LicenceAddToSoftwareView(software: software)
        }
    }
}

struct SoftwareDetails_Previews: PreviewProvider {
    
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
        
        software.id = UUID()
        software.name = "Word"
        software.releaseDate = Date()
        software.info="lorem ipsum"
        software.link="word.com"
        software.editor = editor
        software.category = category
        software.type = lt
        
        return SoftwareDetails(software: software)
    }
}

