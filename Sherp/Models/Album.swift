//
//  Album.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//
import Foundation

struct Album {
  
  var albumID: Int?
  var albumTitle: String?
  
  
  init(albumID:Int?, albumTitle: String?) {
    self.albumID = albumID
    self.albumTitle = albumTitle
  }
}