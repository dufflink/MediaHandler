# MadiaHandler

A swift library for work with photo library, camera and documents.

## Using

#### 1. Import Library
```swift
import MediaHandler
```
#### 2. Create MediaPicker object and use MediaPickerDelegate delegate

```swift
let mediaPicker = MediaPicker()

override func viewDidLoad() {
    mediaPicker.filesDelegate = self
}

extension ViewController: MediaPickerDelegate {
    
    func didPick(_ attachment: UploadAttachment, source: String) {
        //This method will be call when attachment will be pick
    }
    
    func pickedFileIsLarge() {
        //This method will be call if file is large
    }
    
    func userDidDeniedPhotoLibraryPermission() {
        //This method will be call if user did denied photo library permission
    }
    
}

```

#### 3. Create any UIAlertController
```swift
let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
```

Then, use public methods of mediaPicker in UIAlertActions of UIAlertController
```swift
mediaPicker.openPhotoLibrary()
mediaPicker.openDocumentPicker()
mediaPicker.openMenu(.camera)

```
Example:
```swift
let openPhotoLibraryAction = UIAlertAction(title: "Фотоальбомы", style: .default) { _ in
    self.model.mediaPicker.openPhotoLibrary()
}
```
Show your AlertController
```swift
model.mediaPicker.show(rootViewController: self, actionSheet: actionSheet)

```
