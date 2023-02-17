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
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(.hiddenTitleBar)
                
        Settings{
            SettingsView()            
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
