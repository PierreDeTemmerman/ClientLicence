//
//  LicenceAddToClientView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 15/02/2023.
//

import SwiftUI

struct LicenceAddToClientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let client : Client
    @FetchRequest(
        entity: Software.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )var softwares: FetchedResults<Software>
    @State var selectedSoftwareIndex : Int = 0
    var selectedSoftware:  Software? {
        softwares.isEmpty ? nil : softwares[selectedSoftwareIndex]
    }
    @State private var startDate : Date = Date()
    private var endDate : Date?{
        if selectedSoftware != nil && !selectedSoftware!.type!.isUnique{
            var dateComponent = DateComponents()
            dateComponent.day = Int(selectedSoftware!.type!.days)
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
                    Text("Client").foregroundColor(.secondary)
                    Text(client.name!)
                }
                Picker(selection: $selectedSoftwareIndex, label: Text("Logiciel").foregroundColor(.secondary)) {
                    ForEach(softwares.indices, id:\.self){ i in
                        Text(softwares[i].name ?? "")
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
                    }.disabled(selectedSoftware == nil)
                }
            }
        }.padding(20)
    }
    
    private func addLicence(){
        let licence = Licence(context: viewContext)
        licence.id = UUID()
        licence.startDate = startDate
        licence.endDate = endDate
        licence.client = client
        licence.software = selectedSoftware
        
        do{
            try viewContext.save()
        }catch{
            print(error)
        }
    }
    
    private func calculatedDateFormatted()->String{
        if let s = selectedSoftware{
            if s.type!.isUnique{
                return "/ (Licence unique)"
            }
            return endDate!.formatted(Date.FormatStyle().day().month(.twoDigits).year())
        }
            return ""
    }
}

struct LicenceAddToClientView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context: viewContext)
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
        c.profilePicture = NSImage(named: "default")?.tiffRepresentation!
        return LicenceAddToClientView(client: c)
    }
}
