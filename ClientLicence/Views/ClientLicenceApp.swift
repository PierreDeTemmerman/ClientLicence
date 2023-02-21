//
//  ClientLicenceApp.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI

@main
struct ClientLicenceApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.openWindow) var openWindow
    var body: some Scene {
        
        Window("Accueil", id: "home"){
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                })
        }.commands {
            CommandMenu("Configuration") {
                Button("Client"){
                    openWindow(id: "client")
                }
                Button("Logiciel"){
                    openWindow(id: "software")
                }
            }
        }
        
        Window("Client", id: "client"){
            ClientView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        Window("Logiciel", id: "software"){
            SoftwareView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        Settings{
            SettingsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
