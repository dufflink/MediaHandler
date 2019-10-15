//
//  FilePicker.swift
//  technician-cabinet-ios
//
//  Created by Maxim Skorynin on 19/06/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import UIKit
import Photos

public protocol MediaPickerDelegate: class {
    
    func didPick(_ attachment: UploadAttachment, source: String)
    
    func pickedFileIsLarge()
    
    func userDidDeniedPhotoLibraryPermission()
    
}

public final class MeidaPicker: UIImagePickerController {
    
    public weak var filesDelegate: MediaPickerDelegate?
    
    public var rootViewController: UIViewController!
    let fileSizeValidator = FileSizeValidator(maxFileSize: 100)
    
    // MARK: - Public Functions
    
    public func show(rootViewController: UIViewController, actionSheet: UIAlertController) {
        self.rootViewController = rootViewController
        rootViewController.present(actionSheet, animated: true)
    }
    
    public func openDocumentPicker() {
        DispatchQueue.main.async {
            let documentTypes = ["public.text", "com.apple.iwork.pages.pages", "public.data"]
            let documentPiker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
            
            documentPiker.modalPresentationStyle = .fullScreen
            documentPiker.delegate = self
            
            self.rootViewController.present(documentPiker, animated: true)
        }
    }
    
    public func openMenu(_ sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.allowsEditing = true
            self.delegate = self
            
            self.mediaTypes = [MediaType.image.rawValue, MediaType.movie.rawValue]
            self.videoQuality = .typeHigh
            
            self.sourceType = sourceType
            self.rootViewController.present(self, animated: true)
        }
    }
    
    public func openPhotoLibrary() {
        let permission = PHPhotoLibrary.authorizationStatus()
        
        switch permission {
            case .authorized:
                self.openMenu(.photoLibrary)
            case .denied, .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openMenu(.photoLibrary)
                    } else {
                        DispatchQueue.main.async {
                            self.filesDelegate?.userDidDeniedPhotoLibraryPermission()
                        }
                    }
                }
            default:
                break
            }
    }
    
    // MARK: - Private Functions
    
    private func handlePickedMediaData(info: [UIImagePickerController.InfoKey : Any], source: String) {
        guard let type = info[.mediaType] as? String, let mediaType = MediaType(rawValue: type) else {
            return
        }
        
        switch mediaType {
            case .image:
                if var image = info[.originalImage] as? UIImage {
                    let queue = MHOperationQueue()
                    let scaler = UIImageScaler()
                    
                    queue.addOperation {
                        image = scaler.scale(image) ?? image
                        
                        let name = Date().localTime + mediaType.fileExtension.value
                        let attachment = ImageAttachment(image: image, name: name, mimeType: mediaType.fileExtension.mimeType)
                        
                        DispatchQueue.main.async {
                            self.filesDelegate?.didPick(attachment, source: source)
                            self.dismiss(animated: true)
                        }
                    }
                }
            case .movie:
                if let url = info[.mediaURL] as? URL {
                    let attachment = DocumentAttachment(url: url, mimeType: .mov)
                    
                    filesDelegate?.didPick(attachment, source: source)
                    self.dismiss(animated: true)
                }
            }
    }
    
    private func getMIMEType(from url: URL) -> MIMEType {
        let pathExtension = url.pathExtension
        
        if let fileExtension = FileExtension(rawValue: pathExtension) {
            return fileExtension.mimeType
        }
        
        return MIMEType.file
    }
    
}

// MARK: UIDocumentPickerDelegate Functions

extension MeidaPicker: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var fileIsLarge = false
        
        defer {
            controller.dismiss(animated: true) {
                if fileIsLarge {
                    self.filesDelegate?.pickedFileIsLarge()
                }
            }
        }
        
        if fileSizeValidator.validate(by: url.path) {
            let mimeType = getMIMEType(from: url)
            let attachment = DocumentAttachment(url: url, mimeType: mimeType)
            
            filesDelegate?.didPick(attachment, source: "Документы")
        } else {
            fileIsLarge = true
        }
    }
    
}

// MARK: UIImagePickerControllerDelegate Functions

extension MeidaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker.sourceType {
            case .photoLibrary:
                guard let url = info[.referenceURL] as? URL else {
                    return
                }
                
                if fileSizeValidator.validate(by: url) {
                    handlePickedMediaData(info: info, source: "Галерея")
                } else {
                    picker.dismiss(animated: true) {
                        self.filesDelegate?.pickedFileIsLarge()
                    }
                }
            case .camera:
                guard let type = info[.mediaType] as? String, let mediaType = MediaType(rawValue: type) else {
                    return
                }
                
                if mediaType == .movie, let mediaURL = info[.mediaURL] as? URL {
                    if fileSizeValidator.validate(by: mediaURL.path) {
                        handlePickedMediaData(info: info, source: "Камера")
                    } else {
                        picker.dismiss(animated: true) {
                            self.filesDelegate?.pickedFileIsLarge()
                        }
                    }
                    
                    return
                }
                
                handlePickedMediaData(info: info, source: "Камера")
            default:
                break
        }
    }
    
}
