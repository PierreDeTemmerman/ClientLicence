//
//  ClientAddView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 14/02/2023.
//

import SwiftUI

struct ClientAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name : String = ""
    @State private var email : String = ""
    @State private var profilePicture : NSImage?
    
    @State private var message : String?
    @State private var isError : Bool = false
    
    var body: some View {
        VStack {
            Text("Ajout d'un client")
                .font(.largeTitle)
                .padding(20)
            VStack(alignment: .leading){
                Text("Nom du client")
                TextField("Requis",text: $name)
                Text("Adresse email ")
                TextField("Requis", text: $email)
                Text("Photo de profil")
                HStack{
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
            }
            HStack{
                Text(message ?? "")
                    .font(.footnote)
                    .foregroundColor(isError ? .red : .green)
                    .padding(10)
                Spacer()
                Button(action: addClient){
                    Label("Ajouter", systemImage: "checkmark")
                }
            }
        }.padding(20)
    }
    
    private func addClient(){
        let client = Client(context: viewContext)
        client.id = UUID()
        client.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        client.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        client.profilePicture = profilePicture?.tiffRepresentation
        
        do{
            try viewContext.save()
            isError = false
            message = "Le client \"\(client.name!)\" a bien été ajouté"
            resetInput()
        }catch{
            viewContext.delete(client)
            let nsError = error as NSError
            message = "Ajout impossible : \(nsError.localizedDescription)"
            isError = true
        }
    }
    
    private func resetInput(){
        name = ""
        email = ""
        profilePicture = nil
    }
}

struct ClientAddView_Previews: PreviewProvider {
    static var previews: some View {
        ClientAddView()
    }
}
