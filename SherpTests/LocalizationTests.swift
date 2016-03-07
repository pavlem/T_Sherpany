//
//  LocalizationTests.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 3/7/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import XCTest
@testable import Sherp

class LocalizationTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testLocalizedLabelFunctionality() {
    let label = LocalizedLabel(frame: CGRectZero)
    
    let textToLocalize = "LanguageSelection"
    
    let localizations = ["en":"[EN]",
      "fr":"[FR]",
      "it":"[IT]",
      "de":"[DE]",
      "pt":"[PT]",
    ]
    
    for (language, localizedValue) in localizations {
      
      LocalizationHandler.availableLanguages = ["en","fr","it","de","pt"]
      LocalizationHandler.sharedInstace.defaultLanguage = language
      label.text = textToLocalize
      
      XCTAssertEqual(localizedValue, label.text!, "🔴🔴 LocalizedLabel did not localize the label with respect to the default language currectly.")
    }
  }
}










