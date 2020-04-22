//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Oleg Kudimov on 4/12/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit

var imageCash = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        if let cachedImage = imageCash[urlString] {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("failed to fetch post image: ", err)
                return
            }
            
            if url.absoluteString  != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage  = UIImage(data: imageData)
            
            imageCash[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
