//
//  File.swift
//  
//
//  Created by Maxim Skorynin on 14.10.2019.
//

import Foundation

extension Date {
    
    var localTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "dd.MM.yyyy,HH.mm.ss"
        return formatter.string(from: self)
    }
    
}
