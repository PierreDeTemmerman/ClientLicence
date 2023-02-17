//
//  SettingsView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case editors, categories, licenceTypes
    }
    var body: some View {
        TabView {
            EditorSettingsView()
                .tabItem {
                    Label("Editeurs", systemImage: "pencil")
                }
                .tag(Tabs.editors)
            CategorySettingsView()
                .tabItem {
                    Label("Catégories", systemImage: "square.stack.3d.down.right")
                }
                .tag(Tabs.categories)
            LicenceTypeSettingsView()
                .tabItem {
                    Label("Types de licence", systemImage: "doc.text.fill")
                }
                .tag(Tabs.licenceTypes)
        }
        .padding(10)
        .frame(width: 500, height: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
