//
//  UserRealm.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 3/7/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    

  dynamic var name = ""
  dynamic var email = ""
  dynamic var coCatchPhrase = ""
  dynamic var userId = -1

}
