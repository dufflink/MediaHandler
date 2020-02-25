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
    
    /**
     This method will be called when a file is picked.
     
     - parameters:
        - attchment: Model which have information about picked file.
        - source: Type of picker menu (photolibrary, camera or documents).
    */
    
    func didPick(_ attachment: UploadingAttachment, source: String)
    
    func pickedFileIsLarge()
    
    func userDidDeniedPhotoLibraryPermission()
    
    func userDidDeniedCameraPermission()
    
}

public class MediaPicker: NSObject {
    
    public weak var filesDelegate: MediaPickerDelegate?
    weak var rootViewController: UIViewController?
    
    var imagePicker: UIImagePickerController
    
    var fileSizeValidator: FileSizeValidator?
    var imageScaler: UIImageScaler?
    
    // MARK: - Life Cycle
    
    /**
    Returns a newly Media Picker object.
     
     - parameters:
        - rootViewController: UIViewController for presenting of pickers
        - maxFileSize: Use this parameter if you want to validate file size after picking. Validation will not be perform if this paramter is nil.
        - maxImageSideSize: Use this parameter if you want to scale image by largest side with your custom value. Default value is 1280.
    */
    
    public init(rootViewController: UIViewController, maxFileSize: Int?, maxImageSideSize: CGFloat?) {
        if let maxFileSize = maxFileSize {
            fileSizeValidator = FileSizeValidator(maxFileSize: maxFileSize)
        }
        self.rootViewController = rootViewController
        
        imageScaler = UIImageScaler(maxImageSideSize: maxImageSideSize)
        imagePicker = UIImagePickerController()
    }
    
    // MARK: - Public Functions
    
    /**
        Opens a iCloud view for selecting documents.
     
        - returns:
            This method return DocumentAttachment object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadingAttachment, source: String).
    */
    
    public func openDocumentPicker() {
        DispatchQueue.main.async {
            let documentTypes = ["public.text", "com.apple.iwork.pages.pages", "public.data"]
            let documentPiker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
            
            documentPiker.modalPresentationStyle = .fullScreen
            documentPiker.delegate = self
            
            self.rootViewController?.present(documentPiker, animated: true)
        }
    }
    
    /**
        Opens a camera menu with request of permission.
     
         - returns:
         This method return ImageAttachment (picture) or DocumentAttachment (video) object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadingAttachment, source: String)
    */
    
    public func openСamera() {
        let permission = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch permission {
            case .authorized:
                self.openMenu(.camera)
            case .denied, .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openMenu(.camera)
                    } else {
                        DispatchQueue.main.async {
                            self.filesDelegate?.userDidDeniedCameraPermission()
                        }
                    }
                }
            default:
                break
            }
    }
    
    /**
        Opens a photo library menu with request of permission.
     
         - returns:
         This method return ImageAttachment (picture) or DocumentAttachment (video) object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadingAttachment, source: String)
    */
    
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
    
    private func openMenu(_ sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imagePicker.delegate = self
            
            self.imagePicker.mediaTypes = [MediaType.image.rawValue, MediaType.movie.rawValue]
            self.imagePicker.videoQuality = .typeHigh
            
            self.imagePicker.sourceType = sourceType
            self.rootViewController?.present(self.imagePicker, animated: true)
        }
    }
    
    private func handlePickedMediaData(info: [UIImagePickerController.InfoKey : Any], source: String) {
        guard let type = info[.mediaType] as? String, let mediaType = MediaType(rawValue: type) else {
            return
        }
        
        switch mediaType {
            case .image:
                if var image = info[.originalImage] as? UIImage {
                    let queue = MHOperationQueue()
                    
                    queue.addOperation {
                        image = self.imageScaler?.scale(image) ?? image
                        
                        let name = "IMG_\(Date().fileName)\(mediaType.fileExtension.value)"
                        let attachment = ImageAttachment(image: image, name: name, mimeType: mediaType.fileExtension.mimeType)
                        
                        DispatchQueue.main.async {
                            self.filesDelegate?.didPick(attachment, source: source)
                            self.imagePicker.dismiss(animated: true)
                        }
                    }
                }
            case .movie:
                if let url = info[.mediaURL] as? URL {
                    let attachment = DocumentAttachment(url: url, mimeType: .mov)
                    
                    filesDelegate?.didPick(attachment, source: source)
                    self.imagePicker.dismiss(animated: true)
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
    
    private func buildAttachment(by url: URL) {
        let mimeType = getMIMEType(from: url)
        let attachment = DocumentAttachment(url: url, mimeType: mimeType)
        
        filesDelegate?.didPick(attachment, source: "Документы")
    }
    
}

// MARK: UIDocumentPickerDelegate Functions

extension MediaPicker: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var fileIsLarge = false
        
        defer {
            controller.dismiss(animated: true) {
                if fileIsLarge {
                    self.filesDelegate?.pickedFileIsLarge()
                }
            }
        }
        
        if let fileSizeValidator = fileSizeValidator {
            if fileSizeValidator.validate(by: url.path) {
                buildAttachment(by: url)
            } else {
                fileIsLarge = true
            }
        } else {
            buildAttachment(by: url)
        }
    }
    
}

// MARK: UIImagePickerControllerDelegate Functions

extension MediaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        func dismiss() {
            picker.dismiss(animated: true) {
                self.filesDelegate?.pickedFileIsLarge()
            }
        }
        
        switch picker.sourceType {
            case .photoLibrary:
                guard let url = info[.referenceURL] as? URL else {
                    return
                }
                
                if let fileSizeValidator = fileSizeValidator {
                    if fileSizeValidator.validate(by: url) {
                        handlePickedMediaData(info: info, source: "Галерея")
                    } else {
                        dismiss()
                    }
                } else {
                    handlePickedMediaData(info: info, source: "Галерея")
                }
            case .camera:
                guard let type = info[.mediaType] as? String, let mediaType = MediaType(rawValue: type) else {
                    return
                }
                
                if mediaType == .movie, let mediaURL = info[.mediaURL] as? URL {
                    if let fileSizeValidator = fileSizeValidator {
                        if fileSizeValidator.validate(by: mediaURL.path) {
                            handlePickedMediaData(info: info, source: "Камера")
                        } else {
                            dismiss()
                        }
                    } else {
                        handlePickedMediaData(info: info, source: "Камера")
                    }
                    
                    return
                }
                
                handlePickedMediaData(info: info, source: "Камера")
            default:
                break
        }
    }
    
}
