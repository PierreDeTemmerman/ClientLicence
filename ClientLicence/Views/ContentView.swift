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
    @Environment(\.openWindow) var openWindow
    @State var isPresentingClientModal: Bool = false
    @State var isPresentingSoftwareModal: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Spacer()
                    Button(action: {openWindow(id: "client")}) {
                        Label("Clients", systemImage: "person.2.fill")
                    }.controlSize(.large)
                    Spacer()
                    Button(action: {openWindow(id: "software")}) {
                        Label("Logiciels", systemImage: "desktopcomputer")
                    }.controlSize(.large)
                    Spacer()
                }
                Divider()
                LicenceTableView()
            }
            .padding(20)
        }
    }
    /*
    func hideButtons() {
            for window in NSApplication.shared.windows {
                window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
                window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
                window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
            }
        }*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
