//
//  RoundButton.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 28/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit

private var isRound = false


extension UIView {
    
    @IBInspectable var roundButton: Bool {
        
        get {
            return isRound
        }
        
        set {
            isRound = newValue
            
            if isRound {
                self.layer.cornerRadius = self.bounds.size.width / 2.0
                self.clipsToBounds = true
                
                
            }
        }
        
    }
    
    
}

