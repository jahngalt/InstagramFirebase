//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/10/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage?  {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextView()
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 0, height: 100)
       
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddongBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddongBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleShare() {
        
        guard let caption = textView.text, caption.count > 0  else { return }
        guard  let image = self.selectedImage else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("posts").child(fileName)
        ref.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image", err)
                return
            }
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("There is some error: ", error)
                }
                if let url = url {
                    print("successfully uploaded image: ", url.absoluteString)
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    let values = ["imageUrl": url.absoluteString, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
                    
                    Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values) { (err, ref) in
                        if let err = err {
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                            print("Failed to save post into DB : ", err)
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                        print("Successfully saved info to DB")
                        
                    }
                }
            })
        }
    }

    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
