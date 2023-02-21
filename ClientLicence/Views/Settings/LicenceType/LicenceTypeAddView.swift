//
//  NewEditorView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI

struct LicenceTypeAddView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @State var name : String = ""
    @State var days : String = ""
    @State var addLicenceTypeIsError: Bool = false
    @State var addLicenceTypeMessage: String = ""
    
    var body: some View {
        VStack {
            Text("Ajout d'un type de licence")
                .font(.title)
                .padding(15)
            TextField("Nom du type de licence", text: $name)
            TextField("Nombre de jours", text: Binding(get: { days },set: { days = $0.filter { "0123456789".contains($0)}}))
            Text(addLicenceTypeMessage)
                .font(.footnote)
                .foregroundColor(addLicenceTypeIsError ? .red : .green)
            Button(action: addLicenceType){
                Label("Ajouter", systemImage: "plus")
            }
        }
        .frame(width: 350,height: 150)
        .padding(20)
        .fixedSize()
    }
    
    private func addLicenceType(){
        let licenceType = LicenceType(context: DBcontext)
        do{
            licenceType.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            licenceType.days = Int32(days) ?? -1
            licenceType.id = UUID()
            try DBcontext.save()
            addLicenceTypeIsError = false
            addLicenceTypeMessage = "Type de licence \"\(name)\" ajoutée"
            name = ""
            days = ""
        }catch{
            DBcontext.delete(licenceType)
            let nsError = error as NSError
            addLicenceTypeIsError = true
            print(error.localizedDescription)
            addLicenceTypeMessage = "Ajout impossible : "+nsError.localizedDescription
        }
    }
}

struct LicenceTypeAddView_Previews: PreviewProvider {
    static var previews: some View {
        LicenceTypeAddView()
    }
}
