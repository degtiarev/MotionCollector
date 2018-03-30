//
//  SettingsTableVC.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 28/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit


protocol SettingsTableVCDelegate: class {
    func periodChangedNumberSettingsDelegate(_ number: Int)
    func changeIDpressed()
}


class SettingsTableVC: UITableViewController {
    
    
    // Controlls outlets
    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var periodSlider: UISlider!
    @IBOutlet weak var recordNumberLabel: UILabel!
    @IBOutlet weak var currentRecordNumberLabel: UILabel!
    @IBOutlet weak var recordID: UILabel!
    
    
    weak var delegate: SettingsTableVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update start current value
        periodChangedNumber(periodSlider)
    }
    
    
    @IBAction func periodChangedNumber(_ sender: UISlider) {
        // Change moving mode
        sender.setValue(sender.value.rounded(.down), animated: true)
        
        // Update label and send value
        let newValue = Int (sender.value)
        currentPeriodLabel.text = "\(newValue)"
        delegate?.periodChangedNumberSettingsDelegate(newValue)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            delegate?.changeIDpressed()
        }
    }
    
}
