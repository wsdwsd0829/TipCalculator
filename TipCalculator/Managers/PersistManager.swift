//
//  PersistManager.swift
//  TipCalculator
//
//  Created by Sida Wang on 1/27/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

protocol PersistManagerProtocol {
    func loadInputPrice() -> String
    func loadTipPercent() -> Double
    func saveInputPrice(_ inputPriceStr: String)
    func saveTipPercent(_ tipPercent: Double)
}

class PersistManager: NSObject, PersistManagerProtocol {
    var userDefaults = UserDefaults.standard
    
    var currency: String {
        //TODO: set live currency
        return "$"
    }
    
    struct Constants {
        static let defaultTipPercent = 0.15
    }
    struct UserDefaultKey {
        static let InputPrice = "kInputPrice"
        static let TipPercent = "kTipPercent"
    }
    
    func loadInputPrice() -> String {
        return userDefaults.string(forKey: UserDefaultKey.InputPrice) ?? currency //nil if not exist
    }
    
    func loadTipPercent() -> Double {
        let percent = userDefaults.double(forKey: UserDefaultKey.TipPercent) //0 if not exist
        if percent == 0 {
            return Constants.defaultTipPercent
        }
        return percent
    }
    
    func saveInputPrice(_ inputPriceStr: String) {
        userDefaults.set(inputPriceStr, forKey: UserDefaultKey.InputPrice)
        userDefaults.synchronize()
    }
    
    func saveTipPercent(_ tipPercent: Double) {
        userDefaults.set(tipPercent, forKey: UserDefaultKey.TipPercent)
        userDefaults.synchronize()
    }
}
