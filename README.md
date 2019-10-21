# MediaHandler

A swift library for work with photo library, camera and documents.

## Using

#### 1. Import Library

You can use Swift Package Manager for implement this library in your project by url of remote repository:
[https://github.com/dufflink/MediaHandler](https://github.com/dufflink/MediaHandler)

```swift
import MediaHandler
```
#### 2. Create MediaPicker object

```swift
let mediaPicker = MediaPicker(rootViewController: self, maxFileSize: 100, maxImageSideSize: 1280)
```
`rootViewController` . This view controller need for presenting of pickers.

`maxFileSize` (Optional). Use this parameter if you want to validate file size (MB) after picking. Validation will not be perform if this paramter is nil.

`maxImageSideSize` (Optional). Use this parameter if you want to scale image by largest side with your custom value. Default value is 1280.

#### 3. MediaPickerDelegate

```swift
override func viewDidLoad() {
    mediaPicker.filesDelegate = self
}

extension ViewController: MediaPickerDelegate {
    
    func didPick(_ attachment: UploadAttachment, source: String) {
        //This method will be call when attachment will be pick
        
        //source - type of picker menu (photolibrary, camera or documents)
    }
    
    func pickedFileIsLarge() {
        //This method will be call if file is large
    }
    
    func userDidDeniedPhotoLibraryPermission() {
        //This method will be call if user did denied photo library permission
    }
    
    func userDidDeniedCameraPermission() {
        //This method will be call if user did denied camera permission
    }
    
}
```

#### 4. Public main methods


Use public methods of mediaPicker in UIAlertActions of UIAlertController:

`openDocumentPicker()`: Opens a iCloud view for selecting documents. This method return DocumentAttachment object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadAttachment, source: String).

`openPhotoLibrary()`: Opens a photo library menu with request of permission. This method return ImageAttachment (picture) or DocumentAttachment (video) object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadAttachment, source: String)

`openCamera()`: Opens a camera. This method return ImageAttachment (picture) or DocumentAttachment (video) object in delegate (MediaPickerDelegate) method didPick(_ attachment: UploadAttachment, source: String)


```swift
mediaPicker.openPhotoLibrary()
mediaPicker.openDocumentPicker()
mediaPicker.openCamera()
```
Use Example:

Here we create UIAlertController:

```swift
let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

let openPhotoLibraryAction = UIAlertAction(title: "Фотоальбомы", style: .default) { _ in
    self.model.mediaPicker.openPhotoLibrary()
}

alertController.addAction(openPhotoLibraryAction)
```
Or you can use custom view for call public methods

## Attachment Icons

For use your own MIMEType icons, you need to override properties of Icons class:

```swift
public class Icons {
    
    //.mov, .mp4, .wmv, .ogg, .webm
    public static var movie: UIImage?
    
    //.jpeg, .png, .bmp, .gif
    public static var picture: UIImage?
    
    //.rar, .zip
    public static var archive: UIImage?
    
    //unknown
    public static var file: UIImage?
    
    public static var pdf: UIImage?
    public static var keynote: UIImage?
    
    public static var doc: UIImage?
    public static var ppt: UIImage?
    public static var xls: UIImage?
    
    public static var pages: UIImage?
    public static var numbers: UIImage?
    
}
```
Example:

```swift
Icons.archive = UIImage(named: "Archive")
```
or

```swift
Icons.movie = R.image.movie()
```
