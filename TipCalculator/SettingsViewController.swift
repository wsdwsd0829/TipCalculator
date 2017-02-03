//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Sida Wang on 2/3/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    public var viewModel: TipViewModel!
    
    //inputs
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateUICallback = nil
        updateUI()
    }
    
    func updateUI() {
        //set defaults or empty
        tipControl.selectedSegmentIndex = viewModel.tipIndex
    }

    
    @IBAction func didChangeTipPercent(_ tipControl: UISegmentedControl) {
        viewModel.tipPercent = TipPercent.tipPercent(from: tipControl.selectedSegmentIndex)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
