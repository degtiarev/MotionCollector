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
import HealthKit
import WatchConnectivity


class MainIC: WKInterfaceController, WCSessionDelegate {
    
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
    
    // Outlets
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var recIDLabel: WKInterfaceLabel!
    @IBOutlet var recNumberPicker: WKInterfacePicker!
    @IBOutlet var recordDataFromPhoneSwitch: WKInterfaceSwitch!
    
    // Constants
    let IDsAmount = 20
    let currentFrequency: Int = 60
    
    // For session saving
    var nextSessionid: Int = 0
    var recordTime: String = ""
    var sensorOutputs = [SensorOutput]()
    var isRecordDataFromPhone = false
    
    // Variables
    var recordID: Int = 0
    var currentSessionDate: NSDate = NSDate()
    
    // For motion getting
    let motion = CMMotionManager()
    let queue = OperationQueue()
    
    // For background work
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    
    // MARK - WKInterfaceController events
    
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
        
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
        
        status = .waiting
        
        
        // Configure WCSessionDelegate objects
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    // MARK - Control work of getting motion Data
    
    func startGettingData() {
        
        // send info to start data collecting on phone
        if (isRecordDataFromPhone) {
            let WCsession = WCSession.default
            if WCsession.isReachable {
                let data = ["Running": true]
                
                WCsession.sendMessage(data, replyHandler: { (response) in
                    DispatchQueue.main.async {
                        print ("received response: \(response)")
                    }
                }, errorHandler: nil)
            }
        }
        
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .walking
        workoutConfiguration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Start the workout session and device motion updates.
        healthStore.start(session!)
        
        // Check motion availability
        if !motion.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        motion.deviceMotionUpdateInterval = 1.0 / Double(currentFrequency)
        motion.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                
                let currenTime = self.returnCurrentTime()
                let GyroX = deviceMotion!.rotationRate.x
                let GyroY = deviceMotion!.rotationRate.y
                let GyroZ = deviceMotion!.rotationRate.z
                
                let AccX = deviceMotion!.gravity.x + deviceMotion!.userAcceleration.x;
                let AccY = deviceMotion!.gravity.y + deviceMotion!.userAcceleration.y;
                let AccZ = deviceMotion!.gravity.z + deviceMotion!.userAcceleration.z;
                
                print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                // print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                // print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                
                
                let sensorOutput = SensorOutput()
                
                sensorOutput.timeStamp = Date()
                sensorOutput.gyroX = GyroX
                sensorOutput.gyroY = GyroY
                sensorOutput.gyroZ = GyroZ
                sensorOutput.accX = AccX
                sensorOutput.accY = AccY
                sensorOutput.accZ = AccZ
                
                self.sensorOutputs.append(sensorOutput)
                
            }
        }
    }
    
    func stopGettingData() {
        
        // send info to start data collecting on phone
        if (isRecordDataFromPhone) {
            let WCsession = WCSession.default
            if WCsession.isReachable {
                let data = ["Running": false]
                
                WCsession.sendMessage(data, replyHandler: { (response) in
                    DispatchQueue.main.async {
                        print ("received response: \(response)")
                    }
                }, errorHandler: nil)
            }
        }
        
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }
        
        // Stop the device motion updates and workout session.
        motion.stopDeviceMotionUpdates()
        healthStore.end(session!)
        
        // Clear the workout session.
        session = nil
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
        
        let saveURL = getDocumentDirectory().appendingPathComponent("shared_file")
        
        var data = [String: Any]()
        data["SessionID"] = nextSessionid
        data["Date"] = currentSessionDate
        data["Frequency"] = currentFrequency
        data["RecordID"] = recordID
        data["Duration"] = recordTime
        data["Data"] = sensorOutputs
        
        let myData = SensorOutput()
        myData.timeStamp = Date()
        myData.gyroX = 0.0
        myData.gyroY = 0.0
        myData.gyroZ = 0.0
        myData.accX = 2.3333
        myData.accY = 0.0
        myData.accZ = 0.0
        myData.magX = 0.0
        myData.magY = 0.0
        myData.magZ = 0.0
        
        
//        let a = NSKeyedArchiver()
//        try? a.encodeEncodable(myData, forKey: "root")
//        let data1 = a.encodedData
//
//        let u = NSKeyedUnarchiver(forReadingWith: data1)
//        let handAgain = try u.decodeDecodable(SensorOutput.self, forKey: "root")
//        print(handAgain?.accX)
        
        let mutableData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: mutableData)
        try! archiver.encodeEncodable(myData, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()
        
        
        
        let sourceURL = getDocumentDirectory().appendingPathComponent("saveFile")
        mutableData.write(to: sourceURL, atomically: true)
        
        
        
        
        
//
//        let data0 = mutableData.copy() as! Data
//
//        let unarchiver = NSKeyedUnarchiver(forReadingWith: data0)
//        do {
//            if let sensorOutputCopy = try unarchiver.decodeTopLevelDecodable(SensorOutput.self, forKey: NSKeyedArchiveRootObjectKey) {
//                print("deserialized sensor output: \(sensorOutputCopy.accX)")
//            }
//        } catch {
//            print("unarchiving failure: \(error)")
//        }
//
//
//
        
        
        
        
        

//        let mutableData1 = NSMutableData(contentsOfFile: saveURL.absoluteString)
//        
//        let data1 = mutableData1?.copy() as! Data
//        
//        let unarchiver1 = NSKeyedUnarchiver(forReadingWith: data0)
//        do {
//            if let sensorOutputCopy = try unarchiver.decodeTopLevelDecodable(SensorOutput.self, forKey: NSKeyedArchiveRootObjectKey) {
//                print("deserialized sensor output: \(sensorOutputCopy.accX)")
//            }
//        } catch {
//            print("unarchiving failure: \(error)")
//        }
        
        
        
        let session = WCSession.default
        if session.activationState == .activated {
            
            // create a URL from where the file is/will be saved
            let fm = FileManager.default
            let sourceURL = getDocumentDirectory().appendingPathComponent("saveFile")
            
            if !fm.fileExists(atPath: sourceURL.path) {
                
                // the file doesn't exist - create it now
                try? "Hello from phone!".write(to: sourceURL, atomically: true, encoding: String.Encoding.utf8)
                
            }
            
            // the file exists now; send it across the session
            session.transferFile(sourceURL, metadata: nil)
            
        }
        
    
        
        
        sensorOutputs.removeAll()
        nextSessionid += 1
        status = .waiting
    }
    
    var filePath: String {
        //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    func getDocumentDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func recordDataFromPhoneSwitchChanged(_ value: Bool) {
        isRecordDataFromPhone = value
    }
    
    
    
    // MARK - Update changing state
    
    func waiting() {
        recNumberPicker.setEnabled(true)
        timer.stop()
        timer.setDate(Date(timeIntervalSinceNow: 0.0))
        recordDataFromPhoneSwitch.setEnabled(true)
        stopGettingData()
    }
    
    func recording() {
        recNumberPicker.setEnabled(false)
        timer.setDate(Date(timeIntervalSinceNow: 0.0))
        timer.start()
        recordDataFromPhoneSwitch.setEnabled(false)
        startGettingData()
    }
    
    
    
    // MARK - Work with WCSessionDelegate
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        //        DispatchQueue.main.async {
        //
        //            if let text = userInfo["text"] as? String {
        //                print(text)
        //            }
        //        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
