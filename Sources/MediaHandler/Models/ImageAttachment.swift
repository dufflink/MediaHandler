//
//  ImageAttachment.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 21/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import UIKit

/**
    The model is used for photos created by camera and photolibrary.
*/

public class ImageAttachment: UploadingAttachment {
    
    public let image: UIImage
    
    public init(image: UIImage, name: String, mimeType: MIMEType) {
        self.image = image
        super.init(name: name, mimeType: mimeType)
    }
    
}

