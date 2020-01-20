//
//  File.swift
//  
//
//  Created by Maxim Skorynin on 14.10.2019.
//

import Foundation

extension Date {
    
    var fileName: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: self)
    }
    
}
