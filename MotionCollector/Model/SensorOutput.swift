//
//  SensorOutput.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 03/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation


class SensorOutput: Codable {
    
    var timeStamp: Date?
    
    var gyroX: Double?
    var gyroY: Double?
    var gyroZ: Double?
    
    var accX: Double?
    var accY: Double?
    var accZ: Double?
    
    var magX: Double?
    var magY: Double?
    var magZ: Double?
    
    init() {}
}
