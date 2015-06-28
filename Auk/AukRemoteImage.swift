import UIKit
import moa

/**

Downloads and shows a single remote image.

*/
class AukRemoteImage {
  var url: String?
  weak var imageView: UIImageView?
  
  init() { }
  
  /// True when image has been successfully downloaded
  var didFinishDownload = false
  
  func setup(url: String, imageView: UIImageView, settings: AukSettings) {
      
    self.url = url
    self.imageView = imageView
    imageView.image = settings.placeholderImage
  }
  
  /// Sends image download HTTP request.
  func downloadImage(settings: AukSettings) {
    if imageView?.moa.url != nil { return } // Download has already started
    if didFinishDownload { return } // Image has already been downloaded
    
    imageView?.moa.onSuccessAsync = { [weak self] image in
      self?.didReceiveImageAsync(image, settings: settings)
      return image
    }
    
    imageView?.moa.url = url
  }
  
  /// Cancel current image download HTTP request.
  func cancelDownload() {
    // Cancel current download by setting url to nil
    imageView?.moa.url = nil
  }
  
  func didReceiveImageAsync(image: UIImage, settings: AukSettings) {
    didFinishDownload = true
    
    dispatch_async(dispatch_get_main_queue()) { [weak self] in
      self?.animateImageView(image, settings: settings)
    }
  }
  
  private func animateImageView(image: UIImage, settings: AukSettings) {
    self.imageView?.alpha = 0
    let interval = NSTimeInterval(settings.remoteImageAnimationIntervalSeconds)
    
    UIView.animateWithDuration(interval,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 3,
      options: nil,
      animations: {
        self.imageView?.alpha = 1
      },
      completion: { finished in
        
      }
    )
  }
}