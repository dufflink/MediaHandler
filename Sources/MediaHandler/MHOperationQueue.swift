//
//  File.swift
//  
//
//  Created by Maxim Skorynin on 14.10.2019.
//

import Foundation

final class MHOperationQueue: OperationQueue {
    
    override init() {
        super.init()
        
        maxConcurrentOperationCount = 1
        qualityOfService = .background
    }
    
}

