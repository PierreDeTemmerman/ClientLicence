//
//  LicenceDetail.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct LicenceDetail: View {
    var licence : Licence
        
    var body: some View {
        VStack{
            Text("Licence détaillée")
                .font(.largeTitle)
            ScrollView{
                VStack(alignment: .leading){
                    Text("Client")
                        .font(.title)
                    ClientInformations(client: licence.client!)
                    Divider()
                    Text("Logiciel")
                        .font(.title)
                    SoftwareInformation(software: licence.software!)
                        .padding(.horizontal,10)
                    Divider()
                    Text("Licence")
                        .font(.title)
                    LicenceInformation(licence:licence)
                        .padding(10)
                    Spacer()
                }
            }
            
        }.padding(20)
        
    }
}

struct LicenceDetail_Previews: PreviewProvider {
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
        
        return LicenceDetail(licence: licence)
            .frame(width: 1080,height: 720)
    }
}
