//
//  User.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct User {
  
  var name: String?
  var email: String?
  var coCatchPhrase: String?
  var userId: Int?
  
  init(userId:Int?, name: String?, email: String?, coCatchPhrase: String?) {
    self.userId = userId
    self.name = name
    self.email = email
    self.coCatchPhrase = coCatchPhrase
  }
}