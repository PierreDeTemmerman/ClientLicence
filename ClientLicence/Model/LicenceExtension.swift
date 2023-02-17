//
//  LicenceExtension.swift
//  ClientLicence
//
//  Created by DE TEMMERMAN Pierre on 16/02/2023.
//
import Foundation

extension Licence{
    var startDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: self.startDate!)
    }
    
    var endDateString: String {
        if let d = self.endDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            return dateFormatter.string(from: d)
        }
        return "/"
    }
    
    func reniew(){
        if endDate != nil && !software!.type!.isUnique {
            var dateComponent = DateComponents()
            dateComponent.day = Int(software!.type!.days)
            endDate = Calendar.current.date(byAdding: dateComponent, to: endDate!)
        }
    }
}
