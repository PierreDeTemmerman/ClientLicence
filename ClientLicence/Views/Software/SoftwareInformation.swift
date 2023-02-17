//
//  SoftwareInformation.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct SoftwareInformation: View {
    var software : Software
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(software.name!)
                    .font(.title2)
                if software.link != nil && !software.link!.isEmpty{
                    Button(action: {
                        guard let url = URL(string: software.link!)
                        else { return }
                        NSWorkspace.shared.open(url)
                    }) {
                        Image(systemName: "arrow.up.right.square")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .onHover{ isHovered in
                        if(isHovered){
                            NSCursor.pointingHand.set()
                        }else{
                            NSCursor.arrow.set()
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            HStack{
                Text("Référence")
                    .foregroundColor(.secondary)
                Text(software.id!.uuidString)
            }
            
            if software.info != nil && !software.info!.isEmpty{
                HStack{
                    Text("Description")
                        .foregroundColor(.secondary)
                    Text(software.info!)
                }
            }
            HStack{
                Text("Editeur")
                    .foregroundColor(.secondary)
                Text(software.editor!.name!)
            }
            HStack{
                Text("Catégorie")
                    .foregroundColor(.secondary)
                Text(software.category!.name!)
            }
            HStack{
                Text("Type de licence")
                    .foregroundColor(.secondary)
                Text("\(software.type!.name!) (\(software.type!.days) jours)")
            }
            HStack{
                Text("Date de création")
                    .foregroundColor(.secondary)
                Text(software.releaseDate!.formatted(Date.FormatStyle().day().month(.twoDigits).year()))
            }
        }
    }
}

struct SoftwareInformation_Previews: PreviewProvider {
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
        
        return SoftwareInformation(software: software)
    }
}
