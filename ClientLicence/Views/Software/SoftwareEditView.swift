//
//  SoftwareEditView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 17/02/2023.
//

import SwiftUI

struct SoftwareEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isEditionMode : Bool
    @State private var software : Software
    @State private var selectedCategory : Category
    @State private var selectedEditor : Editor
    @State private var selectedLicenceType : LicenceType
    @State private var selectedDate : Date
    @State private var name : String
    @State private var description : String
    @State private var link : String
    
    //Editors
    @FetchRequest(
        entity: Editor.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var editors: FetchedResults<Editor>
    //Categories
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var categories: FetchedResults<Category>
    //LicenceType
    @FetchRequest(
        entity: LicenceType.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var licenceTypes: FetchedResults<LicenceType>
        
    init(isEditionMode: Binding<Bool>, software:Software) {
        _isEditionMode = isEditionMode
        _software = State(initialValue: software)
        _selectedCategory=State(initialValue: software.category!)
        _selectedEditor=State(initialValue: software.editor!)
        _selectedLicenceType=State(initialValue: software.type!)
        _selectedDate=State(initialValue: software.releaseDate!)
        _description=State(initialValue: software.info!)
        _name=State(initialValue: software.name!)
        _link=State(initialValue: software.link!)
    }
        
    var body: some View {
        HStack {
            VStack{
                //NOM
                HStack{
                    Text("Nom")
                    TextField("Requis",text:$name)
                }
                //LIEN
                HStack{
                    Text("Lien")
                    TextField("Optionnel",text:$link)
                }
                //DESCRIPTION
                HStack{
                    Text("Description")
                    TextField("Optionnel",text:$description)
                }
                //EDITEUR
                Picker(selection: $selectedEditor, label: Text("Éditeur")) {
                    ForEach(editors, id:\.self){ e in
                        Text(e.name!)
                    }
                }
                //CATEGORIE
                Picker(selection: $selectedCategory, label: Text("Catégorie")) {
                    ForEach(categories, id:\.self){ c in
                        Text(c.name!)
                    }
                }
                //TYPE LICENCE
                Picker(selection: $selectedLicenceType, label: Text("Type de licence")) {
                    ForEach(licenceTypes, id:\.self){ l in
                        Text(l.name!)
                    }
                }
                //DATE
                DatePicker("Date de création",selection: $selectedDate,displayedComponents: .date)
            }
            .frame(width: 400)
            Spacer()
            VStack{
                Button(action: edit){
                    Label("Enregistrer", systemImage: "checkmark")
                        .frame(width: 100)
                }
                Button(action: {isEditionMode.toggle()}){
                    Label("Annuler", systemImage: "multiply")
                        .frame(width: 100)
                }
            }
        }        
    }
    private func edit(){
        do {
            software.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            software.info = description.trimmingCharacters(in: .whitespacesAndNewlines)
            software.link = link.trimmingCharacters(in: .whitespacesAndNewlines)
            software.releaseDate = selectedDate
            software.editor = selectedEditor
            software.type=selectedLicenceType
            software.category=selectedCategory
            
            try viewContext.save()
            isEditionMode = false
        } catch {
            viewContext.rollback()
            //message = "Impossible de modifier le client, aucun champ ne peut être vide"
        }
    }
}

struct SoftwareEditView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        
        @State var isEdit : Bool = true
        
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
        
        return SoftwareEditView(isEditionMode:$isEdit, software: software)
    }
}
