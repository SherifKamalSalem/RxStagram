//  Created by Sherif Kamal on 5/2/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Photos

class PhotoWriter {
  enum Errors: Error {
    case couldNotSavePhoto
  }

  static func save(_ image: UIImage) -> Observable<String> {
    return Observable.create({ observer in
      var savedAssetId: String?
      PHPhotoLibrary.shared().performChanges({
        let request = PHAssetChangeRequest.creationRequestForAsset(from:
          image)
        savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
      }, completionHandler: { success, error in
        DispatchQueue.main.async {
          if success, let id = savedAssetId {
            observer.onNext(id)
            observer.onCompleted()
          } else {
            
            observer.onError(error ?? Errors.couldNotSavePhoto) }
        }
      })
      return Disposables.create() })
  }
}
