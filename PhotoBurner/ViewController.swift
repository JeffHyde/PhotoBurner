//
//  ViewController.swift
//  PhotoBurner
//
//  Created by Jeff  Hyde on 3/6/19.
//  Copyright © 2019 Jeff  Hyde. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imageController = UIImagePickerController()
    var imageAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        PhotoRequester.requestAccess()
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        getPhoto()
        
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        deletePhoto()
        
    }
    
    func getPhoto() {
        PhotoGetter.get(viewController: self, imagePicerController: imageController) { (completeWithImage, isAuthorized) in
            if completeWithImage == true && isAuthorized == true {
                print("Image Picker Presented")
            } else {
                print("Inform user of fail or auth status")
            }
        }
    }
    
    func deletePhoto() {
        PhotoDeleter.delete(asset: imageAsset) { (complete, error) in
            if complete == true && error == false {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                }
            } else {
                print("Inform user of fail")
            }
        }
        
    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {   }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset, let image = info[.originalImage] as? UIImage {
            self.imageAsset = asset
            dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        } else {
            print("Inform user of fail")
        }
        
    }
    
}
