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
    @State var isPresentingClientModal: Bool = false
    @State var isPresentingSoftwareModal: Bool = false
    //@State var sections : [String] = ["Licences","Clients","Logiciels"]
    //@State var selectedSection : String = "Licences"
    var body: some View {
        /*NavigationSplitView{
            List(selection: $selectedSection) {
                ForEach(sections, id: \.self){ section in
                    Text(section)
                }
            }
            .padding(10)
        }detail:{
            switch selectedSection{
            case "Licences" : LicenceTableView().padding(20)
            case "Clients" : ClientView()
            case "Logiciels" : SoftwareView()
            default : Text("Erreur")
            }
        }*/
        NavigationStack{
            VStack {
                HStack {
                    Spacer()
                    Button(action: {isPresentingClientModal.toggle()}) {
                        Label("Clients", systemImage: "person.2.fill")
                    }.controlSize(.large)
                    Spacer()
                    Button(action: {isPresentingSoftwareModal.toggle()}) {
                        Label("Logiciels", systemImage: "desktopcomputer")
                    }.controlSize(.large)
                    Spacer()
                }
                Divider()
                LicenceTableView()
            }
            .sheet(isPresented: $isPresentingClientModal) {
                ClientView()
            }
            .sheet(isPresented: $isPresentingSoftwareModal) {
                SoftwareView()
            }
            .padding(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
