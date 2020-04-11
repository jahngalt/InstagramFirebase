//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 3/23/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    
    
    //settings for photoButton
    let plusPhotoButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tf.textColor = .black
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()

    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        tf.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSingUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize:14),  NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        self.ref = Database.database().reference()
        //add plusButton
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //hide keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        setBackgroundImage()
        setupInputFields()
    }
    
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    
        plusPhotoButton.layer.cornerRadius  = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.gray.cgColor
        plusPhotoButton.layer.borderWidth = 0.4
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSingUp() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = userNameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count >= 6 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if let err = error {
                print("Failed to create user: ", err)
            }
            print("Successfully created user: ", authResult?.user.uid ?? "There is some problem")
            
            guard  let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
            
            let fileName = NSUUID().uuidString
            let ref = Storage.storage().reference().child("profile_images").child(fileName)
            ref.putData(uploadImage, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image", err)
                    return
                }
                ref.downloadURL(completion: { (url, error) in
                    if let error = error {
                       print("There is some error: ", error)
                    }
                    if let url = url {
                        print("successfully uploaded profile image: ", url.absoluteString)
                        
                        guard let uid = authResult?.user.uid else { return   }
                        let dictionaryValues = ["username": username, "profileImageUrl": url.absoluteString]
                        let values = [uid: dictionaryValues]

                        Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                            if let err = err {
                                print("Failed to save User Info into DB: ", err)
                                return
                            }
                            print("Successfully save user into DB")
                             
                            DispatchQueue.main.async {
                                guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                                let mainTabBarController = scene.window!.rootViewController as? MainTabBarController
                                mainTabBarController?.setupViewControllers()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                })
            }
            
            
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                             animated flag: Bool,
                             completion: (() -> Void)? = nil) {
           viewControllerToPresent.modalPresentationStyle = .fullScreen
           super.present(viewControllerToPresent, animated: true, completion: nil)
           
       }
    
    @objc func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 >= 6
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }


    fileprivate func setBackgroundImage() {
           let background = UIImage(named: "background")

            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
    }
    
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddongBottom: 0, paddingRight: 40, width: 0, height: 200)
    }

}


