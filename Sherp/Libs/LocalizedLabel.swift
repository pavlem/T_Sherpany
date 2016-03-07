//
//  LocalizedLabel.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class LocalizedLabel : UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        super.text = self.text?.localized()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var text: String? {
        get {
            return super.text
        }
        set {
            if let val = newValue as String! {
                super.text = val.localized()
            }
        }
    }
}