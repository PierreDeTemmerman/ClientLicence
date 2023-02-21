//
//  ClientEditView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 15/02/2023.
//

import SwiftUI

struct ClientEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isEditionMode : Bool
    @State private var name : String
    @State private var email : String
    @State private var id : UUID
    @State private var profilePicture : NSImage?
    @State private var message : String?
    
    init(isEditionMode: Binding<Bool>, name: String, email: String, id: UUID, profilePicture: Data?) {
        _isEditionMode = isEditionMode
        _name = State(initialValue: name)
        _email = State(initialValue: email)
        _id = State(initialValue: id)
        if let pp = profilePicture{
            _profilePicture = State(initialValue: NSImage(data: pp))
        }
    }
    
    var body: some View {
        HStack {
            VStack{
                if let pp = profilePicture {
                    ProfilePicture(image: pp)
                    Button("Supprimer la photo") {
                        profilePicture = nil
                    }
                }else{
                    ProfilePicture(image: NSImage(named: "default")!)
                    Button("Ajouter une photo") {
                        let panel = NSOpenPanel()
                        panel.allowedContentTypes = [.image]
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        panel.begin { response in
                            if response == .OK, let url = panel.url, let image = NSImage(contentsOf: url) {
                                self.profilePicture = image
                            }
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                if let m = message{
                    Text(m).foregroundColor(.red)
                }
                TextField("Requis",text : $name)
                TextField("Requis", text : $email)
            }.frame(width: 200)
            Spacer()
            VStack {
                Button(action: editClient){
                    Label("Enregistrer", systemImage: "checkmark")
                        .frame(width: 100)
                }.controlSize(.large)
                Button(action: {isEditionMode.toggle()}){
                    Label("Annuler", systemImage: "multiply")
                        .frame(width: 100)
                }.controlSize(.large)
            }
        }.padding(.horizontal,20)
    }
    
    private func editClient(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Client")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(fetchRequest) as! [Client]
            if let client = results.first {
                client.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                client.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if let pp = profilePicture{
                    client.profilePicture = pp.tiffRepresentation!
                }else{
                    client.profilePicture = nil
                }
                try viewContext.save()
                isEditionMode = false
            }
        } catch {
            viewContext.rollback()
            message = "Impossible de modifier le client, aucun champ ne peut être vide"
        }
        
    }
}

struct ClientEditView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context:viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        @State var isEditionMode = true
        return ClientEditView(
            isEditionMode: $isEditionMode,
            name: c.name!,
            email: c.email!,
            id: c.id!,
            profilePicture: c.profilePicture
        )
    }
}
