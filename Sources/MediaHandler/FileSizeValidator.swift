//
//  FileSizeValidator.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 14.10.2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import Photos

final class FileSizeValidator {
    
    let maxFileSize: Int
    
    // MARK: - Life Cycle
    
    init() {
        maxFileSize = 100
    }
    
    init(maxFileSize: Int) {
        self.maxFileSize = maxFileSize
    }
    
    // MARK: - Public Functions
    
    /**
        Method for validating file size
    */
    
    func validate(by url: URL) -> Bool {
        let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: .none)
        
        if assets.count != 0 {
            let assetResources = PHAssetResource.assetResources(for: assets[0])
            
            if let resource = assetResources.first {
                if let fileSize = (resource.value(forKey: "fileSize") as? Int)?.MByte, fileSize < maxFileSize {
                    return true
                }
            }
        }
        
        return false
    }
    
    func validate(by path: String) -> Bool {
        if let attrs = try? FileManager.default.attributesOfItem(atPath: path) {
            if let fileSize = (attrs[.size] as? Int)?.MByte, fileSize < maxFileSize  {
                return true
            }
        }
        
        return false
    }
    
}
