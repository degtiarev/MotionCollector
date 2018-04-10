//
//  InterfaceController.swift
//  MotionCollectorWatch Extension
//
//  Created by Aleksei Degtiarev on 01/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class MainIC: WKInterfaceController {
    
    // Statuses
    enum Status {
        case waiting
        case recording
    }
    
    var status: Status = Status.waiting {
        willSet(newStatus) {
            
            switch(newStatus) {
            case .waiting:
                waiting()
                break
                
            case .recording:
                recording()
                break
            }
        }
        didSet {
            
        }
    }
    
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var recIDLabel: WKInterfaceLabel!
    @IBOutlet var recNumberPicker: WKInterfacePicker!
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    
    let IDsAmount = 20
    let currentFrequency: Int = 60
    
    
    // For session saving
    var nextSessionid: Int = 0
    var recordTime: String = ""
    var sensorOutputs = [SensorOutput]()
    
    // Changing variable
    var recordID: Int = 0
    var currentSessionDate: NSDate = NSDate()
    
    // For motion getting
    let motion = CMMotionManager()
    
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // prepare recNumberPicker
        var items = [WKPickerItem]()
        for i in 0..<IDsAmount {
            let item = WKPickerItem()
            item.title = String (i)
            items.append(item)
        }
        recNumberPicker.setItems(items)
        
        
        // needs to be implemented
        // findLastSessionId()
        
        status = .waiting
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    
    
    
    
    
    
    
    
    func startGettingData() {
        if motion.isDeviceMotionAvailable {
            
            motion.deviceMotionUpdateInterval = 1.0 / Double(currentFrequency)
            
            let coreMotionHandler : CMDeviceMotionHandler = {(data: CMDeviceMotion?, error: Error?) -> Void in
                // do something with data!.userAcceleration
                // data!. can be used to access all the other properties mentioned above. Have a look in Xcode for the suggested variables or follow the link to CMDeviceMotion I have provided
                
                
                
                let currenTime = self.returnCurrentTime()
                let GyroX = data!.rotationRate.x
                let GyroY = data!.rotationRate.y
                let GyroZ = data!.rotationRate.z
                
                let AccX = data!.gravity.x + data!.userAcceleration.x;
                let AccY = data!.gravity.y + data!.userAcceleration.y;
                let AccZ = data!.gravity.z + data!.userAcceleration.z;
                
                
                print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                
                
                if (self.status == .recording){
                    
                    let sensorOutput = SensorOutput()
                    
                    sensorOutput.timeStamp = Date() as NSDate
                    
                    sensorOutput.gyroX = GyroX
                    sensorOutput.gyroY = GyroY
                    sensorOutput.gyroZ = GyroZ
                    
                    sensorOutput.accX = AccX
                    sensorOutput.accY = AccY
                    sensorOutput.accZ = AccZ
                    
                    
                    self.sensorOutputs.append(sensorOutput)
                    
                } //if (self.status == .recording)
                
                
            }
            motion.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: coreMotionHandler)
            
            
        } else {
            //notify user that no data is available
        }
        
    }
    
    func stopGettingData() {
        motion.stopDeviceMotionUpdates()
    }
    
    func returnCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let nanoseconds = calendar.component(.nanosecond, from: date)
        
        let currentTime = "\(hour):\(minutes):\(seconds):\(nanoseconds)"
        
        return currentTime
    }
    
    
    
    
    
    
    
    
    // MARK - Action controlls
    
    @IBAction func startButtonPressed() {
        
        status = .recording
        
        // Start session recording
        currentSessionDate = NSDate()
    }
    
    @IBAction func stopButtonPressed() {
        
        //        // Finish session recording
        //        timer.invalidate()
        //
        //
        //        currentSession?.id = Int32(nextSessionid)
        //        currentSession?.date = NSDate()
        //        currentSession?.frequency = Int32(currentFrequency)
        //        currentSession?.isWalking = Int32(recordID)
        //
        //
        //        currentSession?.duration = recordTime
        //
        //        for sensorOutput in sensorOutputs {
        //
        //            let characteristicGyro = Characteristic (context:context)
        //            characteristicGyro.x = sensorOutput.gyroX!
        //            characteristicGyro.y = sensorOutput.gyroY!
        //            characteristicGyro.z = sensorOutput.gyroZ!
        //            characteristicGyro.toCharacteristicName = self.characteristicsNames[1]
        //
        //            let characteristicAcc = Characteristic (context:context)
        //            characteristicAcc.x = sensorOutput.accX!
        //            characteristicAcc.y = sensorOutput.accY!
        //            characteristicAcc.z = sensorOutput.accZ!
        //            characteristicAcc.toCharacteristicName = self.characteristicsNames[0]
        //
        //            let characteristicMag = Characteristic (context:context)
        //            characteristicMag.x = sensorOutput.magX!
        //            characteristicMag.y = sensorOutput.magY!
        //            characteristicMag.z = sensorOutput.magZ!
        //            characteristicMag.toCharacteristicName = self.characteristicsNames[2]
        //
        //
        //            let sensorData = SensorData(context: context)
        //            sensorData.timeStamp = sensorOutput.timeStamp
        //            sensorData.addToToCharacteristic(characteristicGyro)
        //            sensorData.addToToCharacteristic(characteristicAcc)
        //            sensorData.addToToCharacteristic(characteristicMag)
        //            self.currentSession?.addToToSensorData(sensorData)
        //
        //        }
        //
        //        sensorOutputs.removeAll()
        //
        //        currentSession = nil
        //        nextSessionid += 1
        
        status = .waiting
        
    }
    
    
    
    
    
    // MARK - Update changing state
    
    func waiting() {
        recNumberPicker.setEnabled(true)
        startButton.setEnabled(true)
        stopButton.setEnabled(false)
        timer.stop()
        timer.setDate(Date(timeIntervalSinceNow: 0.0))
        
        stopGettingData()
    }
    
    func recording() {
        recNumberPicker.setEnabled(false)
        startButton.setEnabled(false)
        stopButton.setEnabled(true)
        timer.start()
        
        startGettingData()
    }
    
    
}
