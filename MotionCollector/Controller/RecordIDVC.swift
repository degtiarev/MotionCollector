//
//  RecordIDVC.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 30/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit

protocol RecordIDVCDelegate: class {
    func recordIDChangedNumberSettingsDelegate(_ number: Int)
}


class RecordIDVC: UITableViewController {
    
    let IDsAmount = 20
    var IDs = [Int]()
    var selectedID: Int = 0
    
    weak var delegate: RecordIDVCDelegate?
    
    
    // MARK - appearance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0..<IDsAmount {
            IDs.append(i)
        }
    }
    
    
    
    // MARK - tableview delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IDs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sessionIDCell") as? SessionIDCell else {  return UITableViewCell() }
        let id = IDs[indexPath.row]
        cell.configureCell(id: id)
        
        if selectedID == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sessionIDCell") as? SessionIDCell else {  return }
        
        if indexPath.row == selectedID {
            cell.accessoryType = .checkmark
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row != selectedID) {
            
            setCheckmark(checkmark: false, row: selectedID)
            setCheckmark(checkmark: true, row: indexPath.row)
            selectedID = indexPath.row
            delegate?.recordIDChangedNumberSettingsDelegate(selectedID)
            
        }
        
    }
    
    
    
    // MARK - other
    func setCheckmark (checkmark: Bool, row: Int) {
        
        guard let cell = tableView.cellForRow(at: IndexPath(item: row, section: 0)) else {return}
        
        if checkmark {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
}
