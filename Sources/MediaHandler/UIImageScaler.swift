//
//  UIImageScaler.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 14.10.2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import UIKit

final class UIImageScaler {
    
    let maxImageSideSize: CGFloat
    
    // MARK: - LifeCycle
    
    init() {
        maxImageSideSize = 1280
    }
    
    init(maxImageSideSize: CGFloat?) {
        if let maxImageSideSize = maxImageSideSize {
            self.maxImageSideSize = maxImageSideSize
        } else {
            self.maxImageSideSize = 1280
        }
    }
    
    // MARK: - Public Functions
    
    func scale(_ image: UIImage) -> UIImage? {
        let size = image.size
        
        var longerSideLength: CGFloat = 0
        
        if size.width > size.height && size.width > maxImageSideSize {
            longerSideLength = size.width
        } else if size.height > size.width && size.height > maxImageSideSize {
            longerSideLength = size.height
        } else {
            return image
        }
        
        let coefficient = longerSideLength / maxImageSideSize
        let scaleFactor = 1 / coefficient
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        return resize(image: image, targetSize: scaledSize)
    }
    
    // MARK: - Private Functions
    
    private func resize(image: UIImage, targetSize: CGSize) -> UIImage? {
       let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
       
       UIGraphicsBeginImageContextWithOptions(targetSize, true, 1)
       image.draw(in: rect)
       
       if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
           UIGraphicsEndImageContext()
           
           return newImage
       }
       
       return nil
    }
    
}
