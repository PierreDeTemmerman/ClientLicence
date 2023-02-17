//
//  ContentView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI
import AppKit
import CoreData

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @State var isPresentingClientModal: Bool = false
    @State var isPresentingSoftwareModal: Bool = false
    
    var body: some View {        
        NavigationStack{
            VStack {
                HStack {
                    Button(action: {isPresentingClientModal.toggle()}) {
                        Text("Client")
                    }
                    Button(action: {isPresentingSoftwareModal.toggle()}) {
                        Text("Logiciel")
                    }
                }
                LicenceTableView()
                    .padding(20)
            }
            .sheet(isPresented: $isPresentingClientModal) {
                ClientView()
            }
            .sheet(isPresented: $isPresentingSoftwareModal) {
                SoftwareView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
