//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 3/30/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            
            //show if not logged in
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true 
    }
    
    //full screen
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    func setupViewControllers() {
        //homeNavController

        let homeNavContoller = templateNavController(unselectdImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        //searchNavController
        
        let searchNavController = templateNavController(unselectdImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //plusNavController
        let plusNavController = templateNavController(unselectdImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //likeNavCOntroller
        let likeNavController = templateNavController(unselectdImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [homeNavContoller,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        
        
        //Modify tab bar item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }
    }
    
    
    fileprivate func templateNavController(unselectdImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController	 = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectdImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}


