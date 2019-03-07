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
    private var asset:PHAsset?
    private var imagePickerController: UIImagePickerController?
    private var completion: ((UIImage?) -> Void)?
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.asset = nil
        picker.dismiss(animated: true) {
            self.imagePickerController = nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let asset = info[.phAsset] as? PHAsset else { return }
        guard let image = info[.originalImage] as? UIImage else { return }
        self.asset = asset
        
        if let com = completion {
            com(image)
        }
        picker.dismiss(animated: true) {
            self.imagePickerController = nil
        }
    }

    func get(from viewController: UIViewController, completion: @escaping ((UIImage?)->()) ) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            guard status == .authorized else { return }
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else { return }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.imagePickerController = picker
            self.completion = completion
            viewController.present(picker, animated: true)
        }
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
