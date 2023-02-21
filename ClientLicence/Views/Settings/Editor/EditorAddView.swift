//
//  NewEditorView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct EditorAddView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @State var name : String = ""
    @State var addEditorIsError: Bool = false
    @State var addEditorMessage: String = ""
    var body: some View {
        VStack {
            Text("Ajout d'un éditeur")
                .font(.title)
                .padding(15)
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    TextField("Nom de l'éditeur", text: $name)
                    Text(addEditorMessage)
                        .font(.footnote)
                        .foregroundColor(addEditorIsError ? .red : .green)
                }.padding([.bottom,.leading],20)
                Button(action: addEditor){
                    Label("Ajouter", systemImage: "plus")
                }.padding([.bottom,.trailing],20)
            }
        }
        .frame(width: 350,height: 125)
        .fixedSize()
    }
    private func addEditor(){
        let editor = Editor(context: DBcontext)
        editor.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        editor.id = UUID()
        do{
            try DBcontext.save()
            addEditorIsError = false
            addEditorMessage = "Editeur \"\(name)\" ajouté"
            name = ""
        }catch{
            DBcontext.delete(editor)
            let nsError = error as NSError
            addEditorIsError = true
            addEditorMessage = "Ajout impossible : "+nsError.localizedDescription
        }
    }
}

struct EditorAddView_Previews: PreviewProvider {
    static var previews: some View {
        EditorAddView()
    }
}
