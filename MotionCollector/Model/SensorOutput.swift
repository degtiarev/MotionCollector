//
//  SensorOutput.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 03/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation


class SensorOutput {
    
    var timeStamp: NSDate?
    
    var gyroX: Double?
    var gyroY: Double?
    var gyroZ: Double?
    
    var accX: Double?
    var accY: Double?
    var accZ: Double?
    
    var magX: Double?
    var magY: Double?
    var magZ: Double?
    
    init(){
        
    }
    
    init(timeStamp: NSDate?, GyroX: Double?, GyroY: Double?, GyroZ: Double?, AccX: Double?, AccY: Double?, AccZ: Double?, MagX: Double?, MagY: Double?, MagZ: Double?) {
        self.timeStamp = timeStamp
        
        self.gyroX = GyroX
        self.gyroY = GyroY
        self.gyroZ = GyroZ
        
        self.accX = AccX
        self.accY = AccY
        self.accZ = AccZ
        
        self.magX = MagX
        self.magY = MagY
        self.magZ = MagZ
    }
    
    
    
}
