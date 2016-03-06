//
//  AlbumPhotos.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation



struct AlbumPhotos {
  
  var id: Int?
  var title: String?
  var url: String?
  var thumbUrl: String?

  
  init(id:Int?, title: String?, url: String?, thumbUrl: String?) {
    self.id = id
    self.title = title
    self.url = url
    self.thumbUrl = thumbUrl
  }
}