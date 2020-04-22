//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/22/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit


class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddongBottom: 0, paddingRight: 0, width: 50, height: 50)
        //circular shape
        profileImageView.layer.cornerRadius = 50 / 2
        //center in the middle of the cell
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddongBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //add separator line between cells
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddongBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
