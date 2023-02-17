//
//  NewEditorView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct CategoryAddView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @State var name : String = ""
    @State var addCategoryIsError: Bool = false
    @State var addCategoryMessage: String = ""
    var body: some View {
        VStack {
            Text("Ajout d'une catégorie")
                .font(.title)
                .padding(15)
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    TextField("Nom de la catégorie", text: $name)
                    Text(addCategoryMessage)
                        .font(.footnote)
                        .foregroundColor(addCategoryIsError ? .red : .green)
                }.padding([.bottom,.leading],20)
                Button(action: addCategory){
                    Label("Ajouter", systemImage: "plus")
                }.padding([.bottom,.trailing],20)
            }
        }
        .frame(width: 350,height: 125)
        .fixedSize()
    }
    private func addCategory(){
        let category = Category(context: DBcontext)
        category.name = name
        category.id = UUID()
        do{
            try DBcontext.save()
            addCategoryIsError = false
            addCategoryMessage = "Catégorie \"\(name)\" ajoutée"
            name = ""
        }catch{
            DBcontext.delete(category)
            let nsError = error as NSError
            addCategoryIsError = true
            addCategoryMessage = "Ajout impossible : "+nsError.localizedDescription
        }
    }
}

struct CategoryAddView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryAddView()
    }
}
