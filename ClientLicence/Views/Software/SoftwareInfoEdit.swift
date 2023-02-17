//
//  SoftwareInfoEdit.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 17/02/2023.
//

import SwiftUI

struct SoftwareInfoEdit: View {
    var software : Software
    @State private var isEditionMode : Bool = false
    
    var body: some View {
        if(!isEditionMode){
            HStack {
                SoftwareInformation(software: software)
                Spacer()
                Button(action: {isEditionMode.toggle()}){
                    Label("Editer", systemImage: "pencil")
                }.controlSize(.large)
            }
        } else{
            SoftwareEditView(
                isEditionMode: $isEditionMode,
                software : software
            )
        }
    }
}

struct SoftwareInfoEdit_Previews: PreviewProvider {
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
        
        return SoftwareInfoEdit(software: software)
    }
}
