//
//  Post.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/11/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
    }
}
 
