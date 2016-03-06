//
//  LocalizationHandler.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.


import Foundation

public class LocalizationHandler {
  
  //MARK: - Properties
  static var sharedInstace = {
    LocalizationHandler(localizationFilePrefix: "default_")
  }()
  
  private var _availableLanguages : [String]!
  
  static var availableLanguages : [String] {
    
    get {
    // Have to remove the "Base" Langugae code from Apple, for whatever reason they added this language...
    if (LocalizationHandler.sharedInstace._availableLanguages != nil) {
    return LocalizationHandler.sharedInstace._availableLanguages
    }
    var localizations = NSBundle.mainBundle().localizations
    // for some reason there is the language code "Base" included... we don't need this
    
    if let index = localizations.indexOf("Base") {
    localizations.removeAtIndex(index)
    }
    LocalizationHandler.sharedInstace._availableLanguages = localizations
    return LocalizationHandler.sharedInstace._availableLanguages
    }
    
    set {
      LocalizationHandler.sharedInstace._availableLanguages = newValue
    }
  }
  
  
  static var availableLanguageDescriptions : [String:String] {
    get {
      var descriptions = [String:String]()
      let languages = NSBundle.mainBundle().localizations
      
      for lang in languages {
        let locale = NSLocale(localeIdentifier:lang)
        let translated = locale.displayNameForKey(NSLocaleLanguageCode, value: lang) as String!
        
        // capitalize all first letters
        if let translationUnwrapped = translated {
          descriptions[lang] = translationUnwrapped.capitalizedString
        }
        
      }
      return descriptions
    }
  }
  

  public var localizationFilePrefix : String
  
  private var lastLocalizedPlistFilename = ""
  private var lastLocalizedPlist         = [String : String]()
  
  let userDefaultsKey_defaultLanguage = "USER_DEFAULT_LANGUAGE"
  private let defaults = DEFAULTS
  
  var defaultLanguage: String {
    
    get {
      // there is no default language selected yet, retrieve it from apps' settings and users' locales
      if (defaults.stringForKey(userDefaultsKey_defaultLanguage) == nil) {
        let bestLanguageMapping = bestMatchingLanguage()
        defaults.setObject(bestLanguageMapping, forKey:userDefaultsKey_defaultLanguage)
      }
      
      return defaults.valueForKey(userDefaultsKey_defaultLanguage) as! String
    }
    
    set(newLanguage) {
      let newValidLanguage = bestMatchingLanguage(newLanguage)
      defaults.setObject(newValidLanguage, forKey:userDefaultsKey_defaultLanguage)
    }
  }
  
  private init(localizationFilePrefix: String) {
    self.localizationFilePrefix = localizationFilePrefix
  }
  
  //MARK: - Private Function without public static accessability
  private func bestMatchingLanguage(desiredLanguage:String? = nil) -> String {
    let preferredLanguages = NSLocale.preferredLanguages()
    let availableLanguages = LocalizationHandler.availableLanguages;
    var bestMatch : String = "";
    
    if let desiredLanguage = desiredLanguage {
      bestMatch = desiredLanguage
    }
    
    
    
    if (!availableLanguages.contains(bestMatch)) {
      bestMatch = availableLanguages.first!
      
      for availableLanguage in availableLanguages {
        if preferredLanguages.contains(availableLanguage) {
          return availableLanguage
        }
      }
      
  
      let match = Array(Set(preferredLanguages).intersect(Set(availableLanguages))).first
      if let match = match {
        return match
      }
    }
    return bestMatch
    
  }
  
  public static func localizedLabelsFromBundleFile(prefix: String? = "default_", bundle: NSBundle? = NSBundle.mainBundle()) -> [String:String] {
    return LocalizationHandler.sharedInstace.localizedLabelsFromBundleFile(prefix, bundle: bundle)
  }
  
  private func localizedLabelsFromBundleFile(prefix: String? = "default_", bundle: NSBundle? = NSBundle.mainBundle()) -> [String:String] {
    if let prefix = prefix {
      self.localizationFilePrefix = prefix
    }
    let filename: String = self.localizationFilePrefix + self.defaultLanguage
    
    if (filename != self.lastLocalizedPlistFilename) {
      var localizedLabels: NSDictionary?
      if let path = bundle!.pathForResource(filename, ofType: "plist") {
        localizedLabels = NSDictionary(contentsOfFile: path)
      }
      if(localizedLabels == nil){
        print("🔴 FAILURE 🔴 Could not find \(filename).plist");
      }
      if let dict = localizedLabels {
        self.lastLocalizedPlist = dict as! [String:String]
      } else {
        self.lastLocalizedPlist = [String:String]()
      }
    }
    return self.lastLocalizedPlist
  }
  
  public static func updateLocalization(defaultLanguage: String, prefix: String? = nil) -> [String: String] {
    return LocalizationHandler.sharedInstace.updateLocalization(defaultLanguage, prefix: prefix)
  }
  
  private func updateLocalization(defaultLanguage: String, prefix: String? = nil) -> [String: String] {
    self.defaultLanguage = defaultLanguage
    return self.localizedLabelsFromBundleFile(prefix)
  }
  
  public static func forceLocalizationUpdate(defaultLanguage: String, prefix: String? = nil) -> [String: String] {
    return LocalizationHandler.sharedInstace.updateLocalization(defaultLanguage, prefix: prefix)
  }
  
  private func forceLocalizationUpdate(defaultLanguage: String, prefix: String? = nil) -> [String: String] {
    self.lastLocalizedPlistFilename = "";
    return self.updateLocalization(defaultLanguage, prefix: prefix)
  }
}