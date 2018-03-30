//
//  SessionIDCell.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 30/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit

class SessionIDCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    
    func configureCell (id: Int){
        idLabel.text = "\(id)"
    }
    
}
