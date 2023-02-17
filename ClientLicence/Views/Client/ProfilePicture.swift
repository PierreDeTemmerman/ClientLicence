//
//  ProfilePicture.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 10/02/2023.
//

import SwiftUI

struct ProfilePicture: View {
    var image:NSImage
    var size:CGFloat = 100
    var body: some View {
        Image(nsImage: image)
            .resizable()
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 1)
            }
            .frame(width: size,height: size)
            .padding(1)
        
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(image: NSImage(named: "default")!)
    }
}
