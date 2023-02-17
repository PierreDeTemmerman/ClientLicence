//
//  GeneralSettingsView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI

struct LicenceTypeSettingsView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @FetchRequest(
        entity: LicenceType.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    var licencesType: FetchedResults<LicenceType>
    @State private var isShowingAddLicenceType: Bool = false
    
    var body: some View {
        VStack {
            List{
                ForEach(licencesType, id: \.self) { licenceType in
                    HStack {
                        Text(licenceType.name!)
                        Divider()
                        Text(licenceType.isUnique ? "Unique" : "\(licenceType.days) jour(s)")
                    }
                }
            }
            HStack(spacing: 0) {
                Button(action: {isShowingAddLicenceType.toggle()}){
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .frame(width: 30, height: 30)
                Divider()
                Spacer()
            }
            .sheet(isPresented: $isShowingAddLicenceType){
                LicenceTypeAddView()
            }
            .frame(height: 30)
        }
    }
}

struct LicenceTypeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LicenceTypeSettingsView()
    }
}
