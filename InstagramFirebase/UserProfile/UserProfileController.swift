//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 3/30/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController,  UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    var user: User?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        collectionView?.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        setupLogOutButton()
        
        //fetchUser()
        fetchOrderedPosts()
    }
    
  
    
    fileprivate func setupLogOutButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                // after logOut we need to present some kind of login controllers
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch  let signOutErr {
                print("Failed to sign out: ", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion:  nil)
    }
    
    
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)  as! UserProfileHeader
        header.user = self.user 
        //header.addSubview(UIImageView())
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
  
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    override func present(_ viewControllerToPresent: UIViewController,
                             animated flag: Bool,
                             completion: (() -> Void)? = nil) {
           viewControllerToPresent.modalPresentationStyle = .fullScreen
           super.present(viewControllerToPresent, animated: true, completion: nil)
           
       }
    
//    fileprivate func fetchPosts() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let ref = Database.database().reference().child("posts").child(uid)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            //print(snapshot.value)
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            dictionaries.forEach { (key, value) in
//                guard let dictionary = value as? [String: Any] else { return }
//                guard let userDictionary = snapshot.value as? [String: Any] else { return }
//
//                let user = User(dictionary: userDictionary)
//                let post = Post(user: user, dictionary: dictionary)
//                self.posts.append(post)
//            }
//
//            self.collectionView.reloadData()
//        }) { (err) in
//            print("Failed to fetch posts", err)
//        }
//    }

    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user: ", err)
        }
    }
    
    fileprivate func fetchOrderedPosts(){
          
          guard let uid = Auth.auth().currentUser?.uid else { return }
          
          let ref = Database.database().reference().child("posts").child(uid)
          
          ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
              
              guard let dictionary = snapshot.value as? [String: Any] else { return }
              let user  =  User(dictionary: dictionary) 
              
              let post = Post(user: user, dictionary: dictionary)
              self.posts.append(post)
              
              self.collectionView.reloadData()
              
              
          }) { (err) in
              print("Failed to fetch ordered possts: ", err)
          }
      }
}


//struct User {
//    let username: String
//    let profileImageUrl: String
//
//    init(dictionary: [String: Any]) {
//        self.username = dictionary["username"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
//    }
//}
