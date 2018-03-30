//
//  RoundButton.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 28/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit


@IBDesignable
class CircleButton: UIButton {
    
    @IBInspectable var isRound: Bool = false {
        
        didSet {
            if isRound {
                setupView()
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if isRound {
            setupView()
        }
    }
    
    func setupView() {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.clipsToBounds = true
    }
    
}

