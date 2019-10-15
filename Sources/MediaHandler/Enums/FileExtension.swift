//
//  FileExtension.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 20/09/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

enum FileExtension: String {
    
    case file = "file"
    
    //MARK: - Video
    
    case mov = "mov"
    case mp4 = "mp4"
    
    case wmv = "wmv"
    
    case ogg = "ogg"
    case webm = "webm"
    
    //MARK: - Pictures
    
    case jpeg = "jpeg"
    case png = "png"
    
    case bmp = "bmp"
    case gif = "gif"
    
    //MARK: - Documents
    
    case pdf = "pdf"
    case key = "key"
    
    case docx = "docx"
    case doc = "doc"
    
    case pptx = "pptx"
    case xlsx = "xlsx"
    case xls = "xls"
    
    case pages = "pages"
    case numbers = "numbers"
    
    case rar = "rar"
    case zip = "zip"
    
    public var value: String {
        return ".\(rawValue)"
    }
    
    public var mimeType: MIMEType {
        switch self {
            case .file:
                return .file
            case .mov:
                return .mov
            case .mp4:
                return .mp4
            case .wmv:
                return .wmv
            case .ogg:
                return .ogg
            case .webm:
                return .webm
            case .jpeg:
                return .jpeg
            case .png:
                return .png
            case .bmp:
                return .bmp
            case .gif:
                return .gif
            case .pdf:
                return .pdf
            case .key:
                return .key
            case .docx, .doc:
                return .docx
            case .pptx:
                return .pptx
            case .xlsx, .xls:
                return .xlsx
            case .pages:
                return .pages
            case .numbers:
                return .numbers
            case .rar:
                return .rar
            case .zip:
                return .zip
        }
    }
    
}
