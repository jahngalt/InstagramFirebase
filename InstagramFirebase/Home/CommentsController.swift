//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 5/5/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .red
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //remove tapbar
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove tapbar
        tabBarController?.tabBar.isHidden = false
    }
    
    
    var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        
        let textField = UITextField()
        textField.placeholder = "Enter a comment"
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddongBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
        
    }()
    
    
    @objc func handleSubmit() {
        print("handling submit...")
    }
    
    //input view
    override var inputAccessoryView: UIView? {
        
        get {
            return containerView
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
