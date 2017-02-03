//
//  ViewController.swift
//  TipCalculator
//
//  Created by Sida Wang on 1/27/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

enum TipPercent {
    case ten, fifteen, twenty, custom(Double), unknown
    var percent: Double {
        switch self {
        case .ten: return 0.1
        case .fifteen: return 0.15
        case .twenty: return 0.2
        case .custom(let cust): return cust
        case .unknown: return -1
        }
    }
    var tipIndex: Int {
        switch self {
        case .ten: return 0
        case .fifteen: return 1
        case .twenty: return 2
        default: return -1 //invalid case
        }
    }
    
    static func tipPercent(from percent: Double) -> TipPercent {
        if percent == 0.1 {
            return .ten
        } else if percent == 0.15 {
            return .fifteen
        } else if percent == 0.2 {
            return .twenty
        } else {
            return .custom(percent)
        }
    }
    
    static func tipPercent(from index: Int) -> TipPercent {
        guard index >= 0 && index <= 2 else{
            return .unknown
        }
        switch index {
        case 0: return .ten
        case 1: return .fifteen
        case 2: return .twenty
        default: return .unknown
        }
    }
}

class TipViewController: UIViewController {
    var viewModel: TipViewModel!
    
    //inputs
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    //outputs
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let pm = PersistManager()
        viewModel = TipViewModel(persistManager: pm)
        
        self.priceTextField.delegate = self
        self.priceTextField.becomeFirstResponder()
        //set defaults or empty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakSelf = self
        viewModel.updateUICallback = {
            weakSelf?.updateUI()
        }
        updateUI()
    }
    
    func updateUI() {
        priceTextField.text = viewModel.inputPriceDisp
        tipControl.selectedSegmentIndex = viewModel.tipIndex
        
        tipLabel.text = viewModel.tipDisp
        totalLabel.text = viewModel.totalDisp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //User action
    @IBAction func didChangeTipPercent(_ tipControl: UISegmentedControl) {
        viewModel.tipPercent = TipPercent.tipPercent(from: tipControl.selectedSegmentIndex)
    }
    
    @IBAction func didChangeInputPrice(_ inputTextField: UITextField) {
        viewModel.inputPriceStr = inputTextField.text!
    }
    
    @IBAction func didTapSetting(_ settingBtn: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            settingsVC.viewModel = self.viewModel
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
}

extension TipViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("TextField: \(textField.text!) Range: \(range.location) \(range.length) ReplaceString: \(string)")
        if range.location == 0 && range.length == 1 && string == "" {
            return false  //if is $ do not relace
        }
        return true
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let input = textField.text, let inputPrice = Double(input) {
//            viewModel.inputPrice = inputPrice
//        }
//        return true
//    }
}

