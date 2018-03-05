//
//  SettingsTableVC.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 28/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit


protocol ClassSettingsTableVCDelegate: class {
    func periodChangedNumberSettingsDelegate(_ number: Int)
    func isWalkingChangedValueSettingsDelegate(_ value: Bool)
}


class SettingsTableVC: UITableViewController {
    
    
    // Controlls outlets
    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var periodSlider: UISlider!
    @IBOutlet weak var recordNumberLabel: UILabel!
    @IBOutlet weak var currentRecordNumberLabel: UILabel!
    @IBOutlet weak var isWalkingSwitch: UISwitch!
    
    
    weak var delegate: ClassSettingsTableVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update start current value
        periodChangedNumber(periodSlider)
        isWalkingChangedValue(isWalkingSwitch)
    }
    
    
    
    @IBAction func periodChangedNumber(_ sender: UISlider) {
        // Change moving mode
        sender.setValue(sender.value.rounded(.down), animated: true)
        
        // Update label and send value
        let newValue = Int (sender.value)
        currentPeriodLabel.text = "\(newValue)"
        delegate?.periodChangedNumberSettingsDelegate(newValue)
    }
    
    
    @IBAction func isWalkingChangedValue(_ sender: UISwitch) {
        delegate?.isWalkingChangedValueSettingsDelegate(sender.isOn)
    }
    
}
