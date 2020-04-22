//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/19/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase



class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    deinit {
        print("deinit is done")
    }
    
    let cellId = "cellId"
    
    // we can't acces to search bar through 'self' if we use 'let'. Should use 'lazy var'
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        //navigationController?.navigationBar.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        let navBar = navigationController?.navigationBar
        
       
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 1, paddingLeft: 8, paddongBottom: 1, paddingRight: 8, width: 0, height: 0)
        
        //Register our cell
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
         
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
           
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("found myself")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
            
            
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }) { (error) in
            print("failed to fetch user", error)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}
