//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/2/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    deinit {
           print("deinit is done")
       }
    
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("there is some error during login: ", err)
                return
            }
            
            print("successfully logged back in with user: ", user?.user.uid ?? "")
            
            
            //Working YAY
            guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            let mainTabBarController = scene.window!.rootViewController as? MainTabBarController
            mainTabBarController?.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                             animated flag: Bool,
                             completion: (() -> Void)? = nil) {
           viewControllerToPresent.modalPresentationStyle = .fullScreen
           super.present(viewControllerToPresent, animated: true, completion: nil)
           
       }
    
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an accout?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize:14),  NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    
    @objc func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 >  0 && passwordTextField.text?.count ?? 0 >= 6
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true 
        view.backgroundColor = .white
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 0, height: 150)
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
    }
    
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddongBottom: 0, paddingRight: 40, width: 0, height: 140)
        
    }
}


