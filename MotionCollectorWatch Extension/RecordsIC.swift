//
//  RecordsIC.swift
//  MotionCollectorWatch Extension
//
//  Created by Aleksei Degtiarev on 06/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import WatchKit
import Foundation


class RecordsIC: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    @IBAction func sendDataPressed() {
    }
    @IBAction func clearDataPressed() {
    }
    
    
}
