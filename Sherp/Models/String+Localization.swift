//  String+Localization.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

extension String {
    func localized() -> String {
        // prefix is nil, as it will use the predefined file prefix
        if let localized = LocalizationHandler.localizedLabelsFromBundleFile()[self] {
            return localized
        }
        return self
    }
}