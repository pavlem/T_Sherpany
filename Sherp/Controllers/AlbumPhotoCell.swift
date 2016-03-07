//
//  AlbumPhotoCell.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class AlbumPhotoCell: UITableViewCell {
  
  @IBOutlet weak var albumPhotoTitleImage: UIImageView!
  @IBOutlet weak var albumPhotoTitle: UILabel!
  @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
  
  override func prepareForReuse() {
    albumPhotoTitleImage.image = nil
    albumPhotoTitle.text = ""
  }
}
