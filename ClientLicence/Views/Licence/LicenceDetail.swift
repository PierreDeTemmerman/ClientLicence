//
//  LicenceDetail.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

import SwiftUI

struct LicenceDetail: View {
    let licence : Licence
    
    
    var body: some View {
        VStack{
            Button(action: {exportPDF()}){
                Label("Télécharger le pdf", systemImage: "arrow.down.doc.fill")
            }.controlSize(.large)
            ShareLink(item: createTempPDF())
            ScrollView{
                LicencePDFView(licence: licence)
                    .frame(width: 496,height: 701)
            }
        }
        .padding(20)
    }
    
    @MainActor
    func createTempPDF()-> URL{
        let tempURL : URL = URL.documentsDirectory.appending(path: "licence.pdf")
        createPDF(url: tempURL)
        return tempURL
    }
    
    @MainActor
    func exportPDF() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        
        let result = panel.runModal()
        if result == NSApplication.ModalResponse.OK {
            createPDF(url: panel.url!)
        }
    }
    
    @MainActor
    func createPDF(url : URL){
        let renderer = ImageRenderer(content: LicencePDFView(licence: licence).frame(width: 496, height: 701))
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
    }
}

struct LicenceDetail_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let c = Client(context: viewContext)
        let software : Software = Software(context: viewContext)
        let editor : Editor = Editor(context: viewContext)
        let category : Category = Category(context: viewContext)
        let lt : LicenceType = LicenceType(context: viewContext)
        let licence : Licence = Licence(context: viewContext)
        
        //Client
        c.id = UUID()
        c.name = "John Doe"
        c.email = "JohnDoe@mail.com"
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
        //Licence
        licence.id = UUID()
        licence.client = c
        licence.startDate = Date()
        licence.endDate = Date()
        licence.software = software
        
        return LicenceDetail(licence: licence)
            .frame(width: 1080,height: 720)
    }
}
