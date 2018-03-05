//
//  Device.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 19/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation


//------------------------------------------------------------------------
// Information about Texas Instruments SensorTag UUIDs can be found at:
// http://processors.wiki.ti.com/index.php/SensorTag_User_Guide#Sensors
//------------------------------------------------------------------------
// From the TI documentation:
//  The TI Base 128-bit UUID is: F0000000-0451-4000-B000-000000000000.
//
//  All sensor services use 128-bit UUIDs, but for practical reasons only
//  the 16-bit part is listed in this document.
//
//  It is embedded in the 128-bit UUID as shown by example below.
//
//          Base 128-bit UUID:  F0000000-0451-4000-B000-000000000000
//          "0xAA01" maps as:   F000AA01-0451-4000-B000-000000000000
//                                  ^--^
//------------------------------------------------------------------------

struct Device {
    
    static let SensorTagAdvertisingUUID = "AA10"
    
    static let TemperatureServiceUUID = "F000AA00-0451-4000-B000-000000000000"
    static let TemperatureDataUUID = "F000AA01-0451-4000-B000-000000000000"
    static let TemperatureConfig = "F000AA02-0451-4000-B000-000000000000"
    static let TemperaturePeriod = "F000AA03-0451-4000-B000-000000000000"
    static let SensorDataIndexTempInfrared = 0
    static let SensorDataIndexTempAmbient = 1
    
    
    static let HumidityServiceUUID = "F000AA20-0451-4000-B000-000000000000"
    static let HumidityDataUUID = "F000AA21-0451-4000-B000-000000000000"
    static let HumidityConfig = "F000AA22-0451-4000-B000-000000000000"
    static let HumidityPeriod = "F000AA23-0451-4000-B000-000000000000"
    static let SensorDataIndexHumidityTemp = 0
    static let SensorDataIndexHumidity = 1
    
    
    static let MovementServiceUUID = "F000AA80-0451-4000-B000-000000000000"
    static let MovementDataUUID = "F000AA81-0451-4000-B000-000000000000"
    static let MovementConfig = "F000AA82-0451-4000-B000-000000000000"
    static let MovementPeriod = "F000AA83-0451-4000-B000-000000000000"
    static let SensorDataIndexGyroX = 0
    static let SensorDataIndexGyroY = 1
    static let SensorDataIndexGyroZ = 2
    static let SensorDataIndexAccX = 3
    static let SensorDataIndexAccY = 4
    static let SensorDataIndexAccZ = 5
    static let SensorDataIndexMagX = 6
    static let SensorDataIndexMagY = 7
    static let SensorDataIndexMagZ = 8
    
    static let IOServiceUUID = "F000AA64-0451-4000-B000-000000000000"
    static let IOServiceDataUUID = "F000AA65-0451-4000-B000-000000000000"
    static let IOServiceConfig = "F000AA66-0451-4000-B000-000000000000"
    
    static let SimpleKeyUUID = "0000FFE0-0000-1000-8000-00805F9B34FB"
    static let SimpleKeyDataUUID = "0000FFE1-0000-1000-8000-00805F9B34FB"
}
