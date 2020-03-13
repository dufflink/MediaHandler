//
//  UploadingAttachment.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 21/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import Foundation

public class UploadingAttachment {
    
    public let name: String
    public let mimeType: MIMEType
    
    public let id: String
    
    public init(name: String, mimeType: MIMEType) {
        self.name = name
        self.mimeType = mimeType
        
        self.id = UUID().uuidString.lowercased()
    }
    
}
