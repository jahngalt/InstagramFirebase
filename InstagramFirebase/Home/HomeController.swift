//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/13/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var posts = [Post]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        //set up homeController drag&refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllPosts()
    }
    
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    
    @objc func handleRefresh() {
        //Not working
        //posts.removeAll()
        //Need to fix follow/unfollow bug 
        fetchAllPosts()
    }
    
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    
    @objc func handleCamera() {
        print("showing camera")
        
        // Present camera controller
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.value, with: { (snapshot) in
            
            // Stop refresh button
            self.collectionView?.refreshControl?.endRefreshing()
            //
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                //print("Key: \(key), Value: \(value)")
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                //let post = Post(dictionary: dictionary)
                self.posts.append(post)
            }
            
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach { (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            }
            
        }) { (err) in
            print("Failed to fetch following user id:  ", err)
        }
    }
    override func present(_ viewControllerToPresent: UIViewController,
                             animated flag: Bool,
                             completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
           super.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username userprofile imageview
        height += view.frame.width
        height += 50 //space for footer
        height += 60 // space for label
        return CGSize(width: view.frame.width, height: height)
    }
    
}
