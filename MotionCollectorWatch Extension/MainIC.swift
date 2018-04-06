//
//  InterfaceController.swift
//  MotionCollectorWatch Extension
//
//  Created by Aleksei Degtiarev on 01/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import WatchKit
import Foundation


class MainIC: WKInterfaceController {
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var recIDLabel: WKInterfaceLabel!
    @IBOutlet var recNumberPicker: WKInterfacePicker!
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    let IDsAmount = 20
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        var items = [WKPickerItem]()
        for i in 0..<IDsAmount {
            let item = WKPickerItem()
            item.title = String (i)
            items.append(item)
        }
        recNumberPicker.setItems(items)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func startButtonPressed() {
        timer.start()
    }
    
    @IBAction func stopButtonPressed() {
        timer.stop()
        timer.setDate(Date(timeIntervalSinceNow: 0))
    }
    
    
}
