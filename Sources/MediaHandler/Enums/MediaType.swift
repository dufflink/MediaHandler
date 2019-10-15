//
//  MediaType.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 20/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

enum MediaType: String {
    
    case image = "public.image"
    case movie = "public.movie"
    
    var fileExtension: FileExtension {
        switch self {
            case .image:
                return .jpeg
            case .movie:
                return .mov
        }
    }
    
}

