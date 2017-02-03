//
//  TipViewModel.swift
//  TipCalculator
//
//  Created by Sida Wang on 1/27/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

protocol TipViewModelProtocol {
    var inputPriceStr: String? { get set }
    var tipPercent: Double { get set }
    func tip() -> Double
    func tipString() -> String
    func totalString() -> String
}

class TipViewModel: NSObject {
    struct ConstantStrings {
        static let Tip = "Tip"
        static let Totoal = "Total"
    }
   
    //init
    var updateUICallback: (() -> ())?
    let persistManager: PersistManagerProtocol
    
    var inputPriceStr: String {
        didSet {
            //updateUI
            var input = inputPriceStr
            input.remove(at: input.startIndex)
            if let inputDouble = Double(input) {
                print("price: \(inputPrice)")
                inputPrice = inputDouble
            } else {
                inputPrice = 0  //when input is ""
            }
            
            persistManager.saveInputPrice(inputPriceStr)
            updateUICallback?()
        }
    }
    
    fileprivate var inputPrice: Double!
    
//    func setInputPrice(from inputPriceStr: String) {
//        var input = inputPriceStr
//        input.remove(at: input.startIndex)
//        if let inputDouble = Double(input) {
//            print("price: \(inputPrice)")
//            inputPrice = inputDouble
//        }
//    }
    
    var tipPercent: TipPercent {
        didSet {
            persistManager.saveTipPercent(tipPercent.percent)
            //updateUI
            updateUICallback?()
        }
    }
    
    init(persistManager: PersistManagerProtocol) {
        self.persistManager = persistManager
        inputPriceStr = self.persistManager.loadInputPrice()
        let percent = self.persistManager.loadTipPercent()
        tipPercent = TipPercent.tipPercent(from: percent)
        
        var input = inputPriceStr
        input.remove(at: input.startIndex)
        if let inputDouble = Double(input) {
            print("price: \(inputPrice)")
            inputPrice = inputDouble
        } else {
            inputPrice = 0  //when input is ""
        }
    }
    //private methods
    
    struct Constants {
        static let defaultFormat = "%.2f"
    }
    fileprivate func tipResult(for price: Double, tipPercent: Double) -> Double {
        let tip = price * tipPercent
        return tip
    }
    fileprivate func totalResult(for price: Double, tipPercent: Double) -> Double{
        let total = price + tipResult(for: price, tipPercent: tipPercent)
        return total
    }

    
    fileprivate func formatedDouble(val: Double, format: String) -> String {
        return String(format: format, val)
    }
    
    //custom methods

    var inputPriceDisp: String {
        return inputPriceStr
    }
    
    var tipIndex: Int {
        return tipPercent.tipIndex
    }
    
    var tipDisp: String {
        let tip = tipResult(for: inputPrice, tipPercent: tipPercent.percent)
        return ConstantStrings.Tip + ": " + formatedDouble(val: tip, format: Constants.defaultFormat)
    }
    
    var totalDisp: String {
        let total = totalResult(for: inputPrice, tipPercent: tipPercent.percent)
        return ConstantStrings.Totoal + ": " + formatedDouble(val: total, format: Constants.defaultFormat)
    }
    
    func saveData() {
        persistManager.saveInputPrice(inputPriceStr)
        persistManager.saveTipPercent(tipPercent.percent)
    }
    
}
