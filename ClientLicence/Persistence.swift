//
//  Persistence.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import CoreData
import AppKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        
        editor.id = UUID()
        editor.name = "Microsoft"
        
        category.id = UUID()
        category.name = "Traitement de texte"
        
        lt.id = UUID()
        lt.isUnique = false
        lt.name = "Journalier"
        lt.days = 1
        
        software.id = UUID()
        software.name = "Word"
        software.info = "lorem ipsum est un rosa populum"
        software.link = "https://www.google.com"
        software.releaseDate = Date()
        software.editor = editor
        software.category = category
        software.type = lt
        
        let abc = ["A","B","C","D","E","F","G","H","I","J"]
        for i in 0..<10 {
            let newClient = Client(context: viewContext)
            newClient.id = UUID()
            newClient.name = "\(abc[i])test"
            newClient.email = "mail\(abc[i])@mail.com"
            newClient.profilePicture = NSImage(named: "default")?.tiffRepresentation!
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ClientLicence")
        //container.viewContext.mergePolicy = NSErrorMergePolicy
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
