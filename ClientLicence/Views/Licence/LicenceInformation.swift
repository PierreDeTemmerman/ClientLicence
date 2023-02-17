//
//  LicenceInformation.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct LicenceInformation: View {
    var licence :Licence
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Référence")
                    .foregroundColor(.secondary)
                Text(licence.id!.uuidString)
            }
            HStack{
                Text("Date début")
                    .foregroundColor(.secondary)
                Text(licence.startDateString)
            }
            HStack{
                Text("Date fin")
                    .foregroundColor(.secondary)
                Text(licence.endDateString)
            }
        }
    }
}

struct LicenceInformation_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context: viewContext)
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        let licence : Licence = Licence(context: viewContext)
        
        //Client
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
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
        //Licence
        licence.id = UUID()
        licence.client = c
        licence.startDate = Date()
        licence.endDate = Date()
        licence.software = software
        
        return LicenceInformation(licence: licence)
    }
}
