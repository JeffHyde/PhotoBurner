//
//  PhotoHelper.swift
//  PhotoBurner
//
//  Created by Jeff  Hyde on 3/6/19.
//  Copyright © 2019 Jeff  Hyde. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PhotoDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image:UIImage?
    var asset:PHAsset?
    var authStatus:PHAuthorizationStatus?
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.asset = nil
        self.image = nil
        picker.dismiss(animated: true,
                       completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let asset = info[.phAsset] as? PHAsset else { return }
        guard let image = info[.originalImage] as? UIImage else { return }
        self.asset = asset
        self.image = image
        picker.dismiss(animated: true,
                       completion: nil)
    }
    
    func dismiss(completion: @escaping (()->()) ) {
        completion()
    }
    
    func requestAccess() {
        PHPhotoLibrary.requestAuthorization( {
            (status) in
            self.authStatus = status
        })
    }
    
    func get(completion: @escaping (()->()) ) {
        guard self.authStatus == .authorized else { return }
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else { return }
        completion()
    }
  
    func delete(completion: @escaping ((UIAlertController?) -> ())) {
        PHPhotoLibrary.shared().performChanges({
            guard let asset = self.asset else { return }
            PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
        }, completionHandler: ({ (complete, error) in
            if error == nil {
                guard complete == true else {return}
                completion(nil)
            } else {
                //MARK: TODO - Needs Work
                let alert = UIAlertController(title: "Deleting Photo Failed",
                                              message: "If this persists please contact the developer",
                                              preferredStyle: .alert)
                completion(alert)
            }
        }))
    }
    
}
