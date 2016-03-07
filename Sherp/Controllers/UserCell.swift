//
//  UserCell.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var coCatchPhrase: UILabel!
  

  override func prepareForReuse() {
    name.text = ""
    email.text = ""
    coCatchPhrase.text = ""
  }
}
