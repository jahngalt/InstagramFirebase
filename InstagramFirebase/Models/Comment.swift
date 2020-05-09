//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 5/7/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
}
