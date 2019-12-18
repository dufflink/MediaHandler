//
//  MIMEType.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 21/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//
import UIKit

public enum MIMEType: String {
    
    case file = "file"
    
    //MARK: - Video
    
    case mov = "video/quicktime"
    case mp4 = "video/mp4"
    
    case wmv = "video/x-ms-wmv"
    
    case ogg = "video/ogg"
    case webm = "video/webm"
    
    //MARK: - Pictures
    
    case jpeg = "image/jpeg"
    case png = "image/png"
    
    case bmp = "image/x-windows-bmp"
    case gif = "image/gif"
    
    //MARK: - Documents
    
    case pdf = "application/pdf"
    case key = "application/vnd.apple.keynote"
    
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    
    case xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    
    case pages = "application/vnd.apple.pages"
    case numbers = "application/vnd.apple.numbers"
    
    case rar = "application/x-rar-compressed"
    case zip = "application/zip"
    
    public var icon: UIImage? {
        switch self {
            case .mov, .mp4, .wmv, .ogg, .webm:
                return Icons.movie
            case .jpeg, .png, .bmp, .gif:
                return Icons.picture
            case .pdf:
                return Icons.pdf
            case .key:
                return Icons.keynote
            case .docx:
                return Icons.doc
            case .pptx:
                return Icons.ppt
            case .xlsx:
                return Icons.xls
            case .pages:
                return Icons.pages
            case .numbers:
                return Icons.numbers
            case .rar, .zip:
                return Icons.archive
            case .file:
                return Icons.file
        }
    }
    
    public var fileExtension: FileExtension {
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
            case .docx:
                return .docx
            case .pptx:
                return .pptx
            case .xlsx:
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

