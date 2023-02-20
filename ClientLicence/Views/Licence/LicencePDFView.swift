//
//  LicencePDFView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 20/02/2023.
//

import SwiftUI

struct LicencePDFView: View {
    var licence : Licence
    var body: some View {
        VStack{
            Text("LICENCE : \(licence.id!.uuidString)" )
                .font(.title2)
            VStack(alignment: .leading){
                Group{
                    Divider()
                    Text("CLIENT" )
                        .font(.title3)
                        .padding(.bottom,5)
                    HStack{
                        if let pp = licence.client!.profilePicture{
                            ProfilePicture(image: NSImage(data: pp)!,size:65)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Nom : \(licence.client!.name!)")
                            Text("Email : \(licence.client!.email!)")
                            Text("Référence : \(licence.client!.id!.uuidString)")
                        }
                    }
                }
                Group{
                    Divider()
                    Text("LOGICIEL" )
                        .font(.title3)
                        .padding(.bottom,5)
                    Text("Nom : \(licence.software!.name!)")
                    Text("Référence : \(licence.software!.id!.uuidString)")
                    Text("Lien : \(licence.software!.link ?? "/")")
                    Text("Description : \(licence.software!.info ?? "/")")
                    Text("Type de licence : \(licence.software!.type!.name!) (\(licence.software!.type!.days) jours)")
                    Text("Date de création : \(licence.software!.releaseDate!.formatted(Date.FormatStyle().day().month(.twoDigits).year()))")
                }
                Group{
                    Divider()
                    Text("LICENCE" )
                        .font(.title3)
                        .padding(.bottom,5)
                    Text("Référence : \(licence.id!.uuidString)")
                    Text("Date du début : \(licence.startDateString)")
                    Text("Date de fin : \(licence.endDateString)")
                    
                }
            }
            Spacer()
        }
        .padding(20)
        .background(.white)
        .foregroundColor(.black)
    }
}

struct LicencePDFView_Previews: PreviewProvider {
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
        
        return LicencePDFView(licence: licence)
            .frame(width: 496,height: 701)
    }
}
