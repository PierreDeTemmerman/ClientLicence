//
//  SoftwareView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 13/02/2023.
//

import SwiftUI
import AppKit
import CoreData

struct SoftwareView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var search : String = ""
    @State private var isDeleteRequested : Bool = false
    @State private var isShowingAdd : Bool = false
    @FetchRequest(
        entity: Software.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    var softwares: FetchedResults<Software>
    
    var filteredSoftwares:[Software]{
        softwares.filter{ software in
            search.isEmpty ? true : software.name!.localizedCaseInsensitiveContains(search)
        }
    }
    
    var groupedSoftwares: [String: [Software]] {
        let groupedDictionary = Dictionary(grouping: filteredSoftwares) { String($0.name!.first!.uppercased()) }
        return groupedDictionary
    }
    
    var sortedKeys: [String] {
        return groupedSoftwares.keys.sorted()
    }
    
    @State private var selectedSoftware: Software?
    
    var body: some View {
        NavigationSplitView{
            VStack {
                List (selection:$selectedSoftware){
                    ForEach(sortedKeys, id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(self.groupedSoftwares[key]!, id: \.self) { software in
                                NavigationLink(value: software) {
                                    Text(software.name!)
                                }
                            }
                        }
                    }
                }
                HStack(spacing: 5) {
                    //ADD BUTTON
                    Button(action: {isShowingAdd.toggle()}){
                        Image(systemName: "plus")
                    }
                    //DELETE BUTTON
                    if selectedSoftware != nil{
                        Button(action: {isDeleteRequested.toggle()}){
                            Image(systemName: "minus")
                        }
                        .disabled(!isSelectedSoftwareDeletable())
                        .confirmationDialog("Êtes-vous sûr de supprimer le logiciel? Cette opération est irréversible", isPresented: $isDeleteRequested){
                            Button("Supprimer", role: .destructive, action: deleteSoftware)
                        }
                        .opacity(isSelectedSoftwareDeletable() ? 1 : 0.7)
                        .help(isSelectedSoftwareDeletable() ? "Supprime définitevement le logiciel" : "Impossible de supprimer un logiciel lié à des licences")
                    }
                    Spacer()
                }
            }.padding(10)
        }detail:{
            if let s = selectedSoftware{
                SoftwareDetails(software: s)
            }else{
                Text("Sélectionnez un logiciel pour voir sa fiche")
            }
        }
        .searchable( text: $search,placement: .sidebar, prompt: "Rechercher un logiciel")
        .frame(minWidth: 720, idealWidth: 1080, minHeight: 480, idealHeight: 720)
        .sheet(isPresented: $isShowingAdd){
            SoftwareAddView()
        }
    }
    
    private func deleteSoftware() {
        if let s = selectedSoftware{
            do {
                viewContext.delete(s)
                try viewContext.save()
                selectedSoftware = nil
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func isSelectedSoftwareDeletable()->Bool{
        if let s = selectedSoftware{
            return s.isDeletable()
        }
        return false
    }
}

struct Software_Previews: PreviewProvider {
    static var previews: some View {
        SoftwareView()
    }
}
