//
//  ViewController.swift
//  PhotoBurner
//
//  Created by Jeff  Hyde on 3/6/19.
//  Copyright © 2019 Jeff  Hyde. All rights reserved.
//

import UIKit
import Photos
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spriteView: SKView!
    
    let photoDelegate = PhotoDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSpriteScene()
    }

    
    @IBAction func getPhotoPressed(_ sender: Any) {
        photoDelegate.get(from: self) { [weak self] image in
            guard let self = self else {  return  print("self is bad")}
            self.imageView.image = image
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
    
    func setUpSpriteScene() {
            guard let scene = SKScene(fileNamed: "FireScene") else { return }
            scene.scaleMode = .aspectFill
            spriteView.allowsTransparency = true
            spriteView.backgroundColor = UIColor.clear
            spriteView.presentScene(scene)
            scene.backgroundColor = UIColor.clear
            spriteView.ignoresSiblingOrder = true
            spriteView.showsFPS = true
            spriteView.showsNodeCount = true
        }
    
    
}
