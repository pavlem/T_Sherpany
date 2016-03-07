//
//  StartVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var startBttn: UIButton!
  @IBOutlet weak var selectLanguageBtn: UIButton!

  
  // MARK: - Lifecycle
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupViewsAndLabels()
  }

  
  // MARK: - Private
  private func setupViewsAndLabels() {
    startBttn.setTitle("start".localized(), forState: UIControlState.Normal)
    selectLanguageBtn.setTitle("selectLanguage".localized(), forState: UIControlState.Normal)
    
    self.view.backgroundColor = Color.testColor
  }
  
  @IBAction func clearDB(sender: UIButton) {
    
    DBHandler().clearAllData()
    DEFAULTS.setObject("false", forKey:userDefaultsKey_dbHasUsers)
  }
}