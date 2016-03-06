//
//  ImageVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var imageUrl = ""
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let urlRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
    let imageTask = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      
      let bigImage = UIImage(data: data!)
      dispatch_async(dispatch_get_main_queue(), {
        
        self.imageView.image = bigImage
      })
    }
    
    imageTask.resume()
  }
}
