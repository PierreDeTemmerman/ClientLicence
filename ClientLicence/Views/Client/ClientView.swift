//
//  ClientView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 10/02/2023.
//

import SwiftUI
import AppKit
import CoreData

struct ClientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedClient: Client?
    @State private var search : String = ""
    @State private var isDeleteRequested : Bool = false
    @State private var isShowingAdd : Bool = false
    
    @FetchRequest(
        entity: Client.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    var clients: FetchedResults<Client>
    
    var filteredClients:[Client]{
        clients.filter{ client in
            search.isEmpty ? true : client.name!.localizedCaseInsensitiveContains(search)
        }
    }
    
    var groupedClients: [String: [Client]] {
        let groupedDictionary = Dictionary(grouping: filteredClients) { String($0.name!.first!.uppercased()) }
        return groupedDictionary
    }
    
    var sortedKeys: [String] {
        return groupedClients.keys.sorted()
    }
    
    
    var body: some View {
        NavigationSplitView{
            VStack {
                List (selection:$selectedClient){
                    ForEach(sortedKeys, id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(self.groupedClients[key]!, id: \.self) { client in
                                NavigationLink(value: client) {
                                    ClientRowView(client:client)
                                        .id(UUID())
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
                    if selectedClient != nil{
                        Button(action: {isDeleteRequested.toggle()}){
                            Image(systemName: "minus")
                        }
                        .disabled(!isSelectedClientDeletable())
                        .confirmationDialog("Êtes-vous sûr de supprimer le client? Cette opération est irréversible", isPresented: $isDeleteRequested){
                            Button("Supprimer", role: .destructive, action: deleteClient)
                        }
                        .opacity(isSelectedClientDeletable() ? 1 : 0.7)
                        .help(isSelectedClientDeletable() ? "Supprime définitevement le client" : "Impossible de supprimer un client lié à des licences")
                    }
                    Spacer()
                }
                .frame(height: 20)
            }
            .padding(10)
        }detail:{
            if selectedClient != nil {
                ClientDetails(client: selectedClient!)
            }
        }
        .searchable( text: $search,placement: .sidebar, prompt: "Rechercher un client")
        .frame(minWidth: 720, idealWidth: 1080, minHeight: 480, idealHeight: 720)
        .sheet(isPresented: $isShowingAdd){
            ClientAddView()
        }        
    }
    
    private func isSelectedClientDeletable()->Bool{
        if let c = selectedClient{
            return c.isDeletable()
        }
        return false
    }
    
    private func deleteClient() {
        print("deleteClick")
        if let c = selectedClient{
            do {
                viewContext.delete(c)
                try viewContext.save()
                selectedClient = nil
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
