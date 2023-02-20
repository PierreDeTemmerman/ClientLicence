//
//  SoftwareAddView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct SoftwareAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name : String = ""
    @State private var info : String = ""
    @State private var link : String = ""
    @State private var releaseDate : Date = Date()
    @State private var message : String?
    @State private var isError : Bool = false
    
    //Editors
    @State var selectedEditorIndex : Int = 0
    var selectedEditor:  Editor {editors[selectedEditorIndex]}
    @FetchRequest(
        entity: Editor.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var editors: FetchedResults<Editor>
    //Categories
    @State var selectedCategoryIndex : Int = 0
    var selectedCategory:  Category {categories[selectedCategoryIndex]}
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var categories: FetchedResults<Category>
    //LicenceType
    @State var selectedLicenceTypeIndex : Int = 0
    var selectedLicenceType:  LicenceType {licenceTypes[selectedLicenceTypeIndex]}
    @FetchRequest(
        entity: LicenceType.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var licenceTypes: FetchedResults<LicenceType>
    
    var body: some View {
        if(editors.isEmpty || categories.isEmpty || licenceTypes.isEmpty){
            Text("Impossible de créer un logiciel actuellement, assurez vous d'avoir ajouté au minimum une catégorie, un éditeur et un type de licence dans les paramètres")
                .padding(20)
        }else{
            VStack {
                Text("Ajout d'un logiciel")
                    .font(.largeTitle)
                    .padding(20)
                VStack(alignment: .leading){
                    Text("Nom du logiciel")
                    TextField("Requis",text: $name)
                    Text("Description")
                    TextField("Optionnel", text: $info)
                    Text("Lien")
                    TextField("Optionnel",text: $link)
                    HStack{
                        DatePicker("Date de création",selection: $releaseDate,displayedComponents: .date)
                        Picker(selection: $selectedEditorIndex, label: Text("Editeur")) {
                            ForEach(editors.indices, id:\.self){ i in
                                Text(editors[i].name!)
                            }
                        }
                    }
                    HStack{
                        Picker(selection: $selectedCategoryIndex, label: Text("Catégorie")) {
                            ForEach(categories.indices, id:\.self){ i in
                                Text(categories[i].name!)
                            }
                        }
                        Picker(selection: $selectedLicenceTypeIndex, label: Text("Type de licence")) {
                            ForEach(licenceTypes.indices, id:\.self){ i in
                                Text(licenceTypes[i].name!)
                            }
                        }
                    }
                }.padding(20)
                Divider()
                HStack{
                    Text(message ?? "")
                        .font(.footnote)
                        .foregroundColor(isError ? .red : .green)
                        .padding(10)
                    Spacer()
                    Button(action: addSoftware){
                        Label("Ajouter", systemImage: "checkmark")
                    }
                    .padding(10)
                }
            }
        }
    }
    
    private func addSoftware(){
        let software = Software(context: viewContext)
        software.id = UUID()
        software.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        software.link = link.trimmingCharacters(in: .whitespacesAndNewlines)
        software.info = info.trimmingCharacters(in: .whitespacesAndNewlines)
        software.releaseDate = releaseDate
        software.editor = selectedEditor
        software.category = selectedCategory
        software.type = selectedLicenceType
        
        message = nil
        isError = false
        
        do{
            try viewContext.save()
            
            message = "Le logiciel \"\(software.name!)\" a bien été ajouté"
            resetInput()
        }catch{
            viewContext.delete(software)
            let nsError = error as NSError
            message = "Ajout impossible : \(nsError.localizedDescription)"
            isError = true
        }
    }
    
    private func resetInput(){
        name = ""
        info = ""
        link = ""
        releaseDate = Date()
        selectedEditorIndex = 0
        selectedLicenceTypeIndex = 0
        selectedCategoryIndex = 0
    }
    
}

struct SoftwareAddView_Previews: PreviewProvider {
    static var previews: some View {
        SoftwareAddView()
    }
}
