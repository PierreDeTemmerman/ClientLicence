//
//  SoftwareExtension.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//

extension Software{
    func isDeletable()->Bool{
        if let l = self.licences {
            return l.count == 0
        }
        return true
    }
}

