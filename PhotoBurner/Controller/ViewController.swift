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
    @IBOutlet var photoDelegate: PhotoDelegate!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = photoDelegate.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePicker()
    }
    
    func setUpImagePicker() {
        imagePickerController.delegate = photoDelegate
        imagePickerController.sourceType = .photoLibrary
        photoDelegate.requestAccess()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        photoDelegate.get {
            self.present(self.imagePickerController, animated: true, completion: {
                print("Picker Completed Navigation")
            })
        }
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        photoDelegate.delete { (alert) in
            if alert == nil {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                }
            } else {
                alert?.present(self, animated: true, completion: nil)
            }
        }
    }
    
}
