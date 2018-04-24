//
//  SessionContainer.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 24/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation

class SessionContainer: Codable {
    
    var nextSessionid: Int?
    var currentSessionDate: Date?
    var currentFrequency: Int?
    var recordID: Int?
    var duration: String?
    var sensorOutputs = [SensorOutput]()
    
    init() {}
}
