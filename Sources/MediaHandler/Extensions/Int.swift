//
//  Int.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 24/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

extension Int {
    
    public var KByte: Int {
        return self / 1024
    }
    
    public var MByte: Int {
        return KByte / 1024
    }
    
}
