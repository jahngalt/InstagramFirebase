//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/19/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import Foundation
import  Firebase

extension Database {
    static func fetchUserWithUID(uid: String, comletion: @escaping (User) -> ()) {
        print("fetching user with uid...", uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            comletion(user)
        }, withCancel: { (err) in
            print("Failed to fetch user for posts: ", err)
        })
    }
}
