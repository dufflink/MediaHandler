//
//  FIleAttachment.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 21/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//
import Foundation

/**
    The model is used for documents and videos.
*/

public class DocumentAttachment: UploadingAttachment {
    
    public let url: URL
    
    public init(url: URL, mimeType: MIMEType) {
        self.url = url
        let name = url.lastPathComponent
        
        super.init(name: name, mimeType: mimeType)
    }
    
}
