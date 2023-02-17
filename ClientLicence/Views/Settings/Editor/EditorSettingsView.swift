//
//  GeneralSettingsView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI

struct EditorSettingsView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @FetchRequest(
        entity: Editor.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    var editors: FetchedResults<Editor>
    @State private var isShowingAddEditor: Bool = false
    
    var body: some View {
        VStack {
            List{
                ForEach(editors, id: \.self) { editor in
                    Text(editor.name!)
                }
            }
            HStack(spacing: 0) {
                Button(action: {isShowingAddEditor.toggle()}){
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .frame(width: 30, height: 30)
                Divider()
                Spacer()
            }
            .sheet(isPresented: $isShowingAddEditor){
                EditorAddView()
            }
            .frame(height: 30)
        }
    }
    /*
    private func del(){
        for e in editors{
            DBcontext.delete(e)
        }
        do{
            try DBcontext.save()
        }catch{
            
        }
    }
     */
}

struct EditorSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EditorSettingsView()
    }
}
