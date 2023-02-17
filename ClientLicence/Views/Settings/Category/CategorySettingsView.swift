//
//  GeneralSettingsView.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 09/02/2023.
//

import SwiftUI

struct CategorySettingsView: View {
    @Environment(\.managedObjectContext) private var DBcontext
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    var categories: FetchedResults<Category>
    @State private var isShowingAddCategory: Bool = false
    
    var body: some View {
        VStack {
            List{
                ForEach(categories, id: \.self) { category in
                    Text(category.name!)
                }
            }
            HStack(spacing: 0) {
                Button(action: {isShowingAddCategory.toggle()}){
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .frame(width: 30, height: 30)
                Divider()
                Spacer()
            }
            .sheet(isPresented: $isShowingAddCategory){
                CategoryAddView()
            }
            .frame(height: 30)
        }
    }
}

struct CategorySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySettingsView()
    }
}
