//
//  UploadAttachment.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 21/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

public class UploadAttachment {
    
    public let name: String
    public let mimeType: MIMEType
    
    init(name: String, mimeType: MIMEType) {
        self.name = name
        self.mimeType = mimeType
    }
    
}