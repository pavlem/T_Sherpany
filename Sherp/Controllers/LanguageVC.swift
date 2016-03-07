//
//  LanguageVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class LanguageVC: UITableViewController {
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
  }
  
  // MARK: - Private
  private func setupTableView() {
    // Table view itself
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
  

  // MARK: - Delegates
  // MARK: Table view data source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return LocalizationHandler.availableLanguageDescriptions.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("LanguageCell", forIndexPath: indexPath)
      
      let supportedLanguagesDictionary = LocalizationHandler.availableLanguageDescriptions
      let supportedLanguagesAbbreviations = LocalizationHandler.availableLanguages
      let supportedLanguageAbbreviation = LocalizationHandler.availableLanguages[indexPath.row]
      let supportedLanguageName = supportedLanguagesDictionary[supportedLanguageAbbreviation]
      
      cell.textLabel?.text = supportedLanguageName
      
      if supportedLanguagesAbbreviations[indexPath.row] == DEFAULTS.stringForKey(userDefaultsKey_defaultLanguage) {
        cell.accessoryType = .Checkmark
      }

      return cell
  }
  
  
  // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
    let visibleCells = tableView.visibleCells
    for cell in visibleCells {
      cell.accessoryType = .None
    }
    
    return indexPath
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
    
    LocalizationHandler.sharedInstace.defaultLanguage = LocalizationHandler.availableLanguages[indexPath.row]
    
    navigationController?.popViewControllerAnimated(true)
  }
}