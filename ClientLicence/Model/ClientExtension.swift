//
//  ClientExtension.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 15/02/2023.
//

extension Client{
    func isDeletable()->Bool{
        if let l = self.licences {
            return l.count == 0
        }
        return true
    }
}
