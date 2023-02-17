//
//  LicenceAddToSoftwareView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct LicenceAddToSoftwareView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let software : Software
    @FetchRequest(
        entity: Client.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )var clients: FetchedResults<Client>
    @State var selectedClientIndex : Int = 0
    var selectedClient:  Client? {
        clients.isEmpty ? nil : clients[selectedClientIndex]
    }
    @State private var startDate : Date = Date()
    private var endDate : Date?{
        if !software.type!.isUnique{
            var dateComponent = DateComponents()
            dateComponent.day = Int(software.type!.days)
            return Calendar.current.date(byAdding: dateComponent, to: startDate)
        }
        return nil
    }
    
    var body: some View {
        VStack{
            Text("Ajout d'une licence")
                .font(.largeTitle)
                .padding(10)
            VStack(alignment: .leading){
                HStack{
                    Text("Logiciel").foregroundColor(.secondary)
                    Text(software.name!)
                }
                Picker(selection: $selectedClientIndex, label: Text("Client").foregroundColor(.secondary)) {
                    ForEach(clients.indices, id:\.self){ i in
                        Text(clients[i].name ?? "")
                    }
                }
                HStack{
                    Text("A partir du").foregroundColor(.secondary)
                    DatePicker("",selection: $startDate,displayedComponents: .date)
                }
                HStack{
                    Text("Se termine le").foregroundColor(.secondary)
                    Text(calculatedDateFormatted())
                }
                HStack{
                    Spacer()
                    Button(action: addLicence){
                        Label("Ajouter", systemImage: "checkmark")
                    }.disabled(selectedClient == nil)
                }
            }
        }.padding(20)
    }
    
    private func addLicence(){
        let licence = Licence(context: viewContext)
        licence.id = UUID()
        licence.startDate = startDate
        licence.endDate = endDate
        licence.client = selectedClient
        licence.software = software
        
        do{
            try viewContext.save()
        }catch{
            print(error)
        }
    }
    
    private func calculatedDateFormatted()->String{
            if software.type!.isUnique{
                return "/ (Licence unique)"
            }
            return endDate!.formatted(Date.FormatStyle().day().month(.twoDigits).year())
    }
}

struct LicenceAddToSoftwareView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        
        //Editor
        editor.id = UUID()
        editor.name = "Microsoft"
        //Category
        category.id = UUID()
        category.name = "Traitement de texte"
        //Licence Type
        lt.id = UUID()
        lt.isUnique = false
        lt.name = "Journalier"
        lt.days = 1
        //Software
        software.id = UUID()
        software.name = "Word"
        software.releaseDate = Date()
        software.info="lorem ipsum"
        software.link="word.com"
        software.editor = editor
        software.category = category
        software.type = lt
        return LicenceAddToSoftwareView(software: software)
    }
}
