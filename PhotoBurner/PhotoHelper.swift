//
//  PhotoHelper.swift
//  PhotoBurner
//
//  Created by Jeff  Hyde on 3/6/19.
//  Copyright © 2019 Jeff  Hyde. All rights reserved.
//

import Foundation
import Photos
struct PhotoGetter {
    static func get(viewController: UIViewController, imagePicerController: UIImagePickerController, completion: @escaping ((_ completeWithImage: Bool, _ authStatus: Bool)-> Void)) {
        if UserDefaults.standard.bool(forKey: DefaultKeys.imageAuthStatus) == true {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                viewController.present(imagePicerController, animated: true) {
                    completion(true, true)
                }
            } else {
                completion(false, true)
            }
        } else {
            completion(false, false)
        }
        
    }
}
struct PhotoDeleter {
    static func delete(asset: PHAsset?, completion: @escaping ((_ complete: Bool, _ error: Bool) -> Void) ) {
        PHPhotoLibrary.shared().performChanges({
            guard let asset = asset else {return}
            PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
        }) { (complete, error) in
            if error != nil {
                completion(false, true)
            } else {
                if complete == true {
                    completion(true, false)
                } else {
                    completion(false, false)
                }
            }
        }
        
    }

}

struct PhotoRequester {
    static func requestAccess() {
        PHPhotoLibrary.requestAuthorization( {
            (status) in
            if status == .authorized {
                  UserDefaults.standard.set(true, forKey: DefaultKeys.imageAuthStatus)
            } else {
                  UserDefaults.standard.set(false, forKey: DefaultKeys.imageAuthStatus)
            }
        })
        
    }
    
}
