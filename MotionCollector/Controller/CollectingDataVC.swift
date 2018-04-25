//
//  CollectingDataVC.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 19/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData
import WatchConnectivity


class CollectingDataVC: UIViewController, WCSessionDelegate, SettingsTableVCDelegate, RecordIDVCDelegate {
    
    
    // Statuses
    enum Status {
        case waiting
        case recording
    }
    
    var status: Status = Status.waiting {
        willSet(newStatus) {
            
            switch(newStatus) {
            case .waiting:
                print ("Stop recording on iPhone")
                waiting()
                break
                
            case .recording:
                print ("Start recording on iPhone")
                recording()
                break
            }
        }
        didSet {
            
        }
    }
    
    
    // Settings view controller
    weak var settingsTableVC:SettingsTableVC?
    
    
    // Controlls outlets
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var recordStatusImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    // For session saving
    var currentSession: Session? = nil
    var nextSessionid: Int = 0
    var recordTime: String = ""
    var sensorOutputs = [SensorOutput]()
    var sensorWatchOutputs = [SensorOutput]()
    var characteristicsNames  = [CharacteristicName]()
    var sessionType: SessionType = SessionType.OnlyPhone
    var sensors = [Sensor]()
    
    
    // Record stopwatch
    var startTime = TimeInterval()
    var UIUpdateTimer = Timer()
    
    
    // Changing variable
    var currentFrequency: Int = 0
    var recordID: Int = 0
    
    
    // For motion getting
    let motion = CMMotionManager()
    var motionUpdateTimer = Timer()
    
    
    // MARK - Starting app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fillTestData()
        
        addNamesOfCharacteristics()
        addSensorIDs()
        
        status = .waiting
        
        // Prepare for session
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        findLastSessionId()
    }
    
    
    // MARK - connecting with delegates
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let settingsTableVC = destination as? SettingsTableVC {
            
            settingsTableVC.delegate = self
            self.settingsTableVC = segue.destination as? SettingsTableVC
        }
        
        if let recordIDVC = destination as? RecordIDVC {
            recordIDVC.delegate = self
            
            if let recordID = sender as? Int {
                recordIDVC.selectedID = recordID
            }
        }
        
    }
    
    
    
    // MARK - start / stop getting motion data
    
    func startGettingData() {
        
        // Make sure the motion hardware is available.
        if self.motion.isAccelerometerAvailable, self.motion.isGyroAvailable, self.motion.isMagnetometerAvailable {
            
            self.motion.accelerometerUpdateInterval = 1.0 / Double (currentFrequency)
            self.motion.gyroUpdateInterval = 1.0 / Double (currentFrequency)
            self.motion.magnetometerUpdateInterval = 1.0 / Double (currentFrequency)
            
            self.motion.startAccelerometerUpdates()
            self.motion.startGyroUpdates()
            self.motion.startMagnetometerUpdates()
            
            // Configure a timer to fetch the data.
            self.motionUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0/Double (currentFrequency), repeats: true, block: { (timer1) in
                // Get the motion data.
                if let dataAcc = self.motion.accelerometerData, let dataMag = self.motion.magnetometerData, let dataGyro = self.motion.gyroData {
                    
                    //let currenTime = self.returnCurrentTime()
                    
                    let GyroX = dataGyro.rotationRate.x
                    let GyroY = dataGyro.rotationRate.y
                    let GyroZ = dataGyro.rotationRate.z
                    
                    let AccX = dataAcc.acceleration.x
                    let AccY = dataAcc.acceleration.y
                    let AccZ = dataAcc.acceleration.z
                    
                    let MagX = dataMag.magneticField.x
                    let MagY = dataMag.magneticField.y
                    let MagZ = dataMag.magneticField.z
                    
                    
                    //print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                    //print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                    //print ( "Mag : \(currenTime) \(MagX), \(MagY), \(MagZ)")
                    
                    
                    let sensorOutput = SensorOutput()
                    
                    sensorOutput.timeStamp = Date()
                    
                    sensorOutput.gyroX = GyroX
                    sensorOutput.gyroY = GyroY
                    sensorOutput.gyroZ = GyroZ
                    
                    sensorOutput.accX = AccX
                    sensorOutput.accY = AccY
                    sensorOutput.accZ = AccZ
                    
                    sensorOutput.magX = MagX
                    sensorOutput.magY = MagY
                    sensorOutput.magZ = MagZ
                    
                    self.sensorOutputs.append(sensorOutput)
                    
                }
            }
            )}
    }
    
    func stopGettingData() {
        motionUpdateTimer.invalidate()
        motionUpdateTimer = Timer()
        self.motion.stopGyroUpdates()
        self.motion.stopAccelerometerUpdates()
        self.motion.stopMagnetometerUpdates()
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
    
    
    
    // MARK - Delegate settings updates
    
    func periodChangedNumberSettingsDelegate(_ number: Int){
        currentFrequency = number
    }
    
    func changeIDpressed(){
        performSegue(withIdentifier: "toRecordIDSettings", sender: recordID)
    }
    
    func recordIDChangedNumberSettingsDelegate(_ number: Int){
        recordID = number
        settingsTableVC?.recordID.text = "\(number)"
    }
    
    
    
    // MARK - Action controlls
    
    @IBAction func StartButtonpressed(_ sender: Any) {
        status = .recording
        
        startGettingData()
        UIUpdateTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
        
        // Start session recording
        currentSession = Session(context: context)
        currentSession?.id = Int32(nextSessionid)
        currentSession?.date = NSDate()
        currentSession?.frequency = Int32(currentFrequency)
        currentSession?.recordID = Int32(recordID)
        currentSession?.type = Int32(sessionType.rawValue)
    }
    
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
        // Finish session recording
        UIUpdateTimer.invalidate()
        currentSession?.duration = recordTime
        
        for sensorOutput in sensorOutputs {
            
            let characteristicGyro = Characteristic (context:context)
            characteristicGyro.x = sensorOutput.gyroX!
            characteristicGyro.y = sensorOutput.gyroY!
            characteristicGyro.z = sensorOutput.gyroZ!
            characteristicGyro.toCharacteristicName = self.characteristicsNames[1]
            
            let characteristicAcc = Characteristic (context:context)
            characteristicAcc.x = sensorOutput.accX!
            characteristicAcc.y = sensorOutput.accY!
            characteristicAcc.z = sensorOutput.accZ!
            characteristicAcc.toCharacteristicName = self.characteristicsNames[0]
            
            let characteristicMag = Characteristic (context:context)
            characteristicMag.x = sensorOutput.magX!
            characteristicMag.y = sensorOutput.magY!
            characteristicMag.z = sensorOutput.magZ!
            characteristicMag.toCharacteristicName = self.characteristicsNames[2]
            
            
            let sensorData = SensorData(context: context)
            sensorData.timeStamp = sensorOutput.timeStamp! as NSDate
            sensorData.addToToCharacteristic(characteristicGyro)
            sensorData.addToToCharacteristic(characteristicAcc)
            sensorData.addToToCharacteristic(characteristicMag)
            sensorData.toSensor = sensors[0]
            
            self.currentSession?.addToToSensorData(sensorData)
            
        }
        
        sensorOutputs.removeAll()
        
        if sessionType == SessionType.OnlyPhone {
            ad.saveContext()
            currentSession = nil
        }
        
        nextSessionid += 1
        stopGettingData()
        status = .waiting
    }
    
    
    
    
    // MARK - Update UI Timer
    
    //Update Time Function
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt16(elapsedTime * 1000)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%03d", fraction)
        
        //concatenate minuts, seconds and milliseconds as assign it to the UILabel
        recordTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        recordTime = "\(strMinutes):\(strSeconds)"
    }
    
    
    
    // MARK - Update changing state
    
    func waiting() {
        settingsTableVC?.periodSlider.isEnabled = true
        settingsTableVC?.currentRecordNumberLabel.text =  "\(nextSessionid)"
        settingsTableVC?.recordNumberLabel.text = "Next record number:"
        recordStatusImage.isHidden = true
        recordTimeLabel.isHidden = false
        recordTimeLabel.text = "00:00:000"
        startButton.isHidden = false
        stopButton.isHidden = false
        startButton.isEnabled = true
        stopButton.isEnabled = false
        settingsTableVC?.tableView.allowsSelection = true
    }
    
    func recording() {
        settingsTableVC?.periodSlider.isEnabled = false
        recordStatusImage.isHidden = false
        settingsTableVC?.currentRecordNumberLabel.isHidden = false
        settingsTableVC?.currentRecordNumberLabel.text = "\(nextSessionid)"
        startButton.isEnabled = false
        stopButton.isEnabled = true
        settingsTableVC?.tableView.allowsSelection = false
        settingsTableVC?.recordNumberLabel.text = "Record number:"
    }
    
    
    
    //  MARK - Filling data for testing datamodel
    
    func fillTestData(){
        
        let characteristicName1 = CharacteristicName (context:context)
        characteristicName1.name = "Gyro"
        let characteristicName2 = CharacteristicName (context:context)
        characteristicName2.name = "Acc"
        let characteristicName3 = CharacteristicName (context:context)
        characteristicName3.name = "Mag"
        
        
        let characteristic1 = Characteristic (context:context)
        characteristic1.x = 0.1
        characteristic1.y = 0.1
        characteristic1.z = 0.1
        characteristic1.toCharacteristicName = characteristicName1
        let characteristic2 = Characteristic (context:context)
        characteristic2.x = 0.2
        characteristic2.y = 0.2
        characteristic2.z = 0.2
        characteristic2.toCharacteristicName = characteristicName1
        let characteristic3 = Characteristic (context:context)
        characteristic3.x = 0.3
        characteristic3.y = 0.3
        characteristic3.z = 0.3
        characteristic3.toCharacteristicName = characteristicName1
        let characteristic1a = Characteristic (context:context)
        characteristic1a.x = 0.1
        characteristic1a.y = 0.1
        characteristic1a.z = 0.1
        characteristic1a.toCharacteristicName = characteristicName2
        let characteristic2a = Characteristic (context:context)
        characteristic2a.x = 0.2
        characteristic2a.y = 0.2
        characteristic2a.z = 0.2
        characteristic2a.toCharacteristicName = characteristicName2
        let characteristic3a = Characteristic (context:context)
        characteristic3a.x = 0.3
        characteristic3a.y = 0.3
        characteristic3a.z = 0.3
        characteristic3a.toCharacteristicName = characteristicName2
        let characteristic1b = Characteristic (context:context)
        characteristic1b.x = 0.1
        characteristic1b.y = 0.1
        characteristic1b.z = 0.1
        characteristic1b.toCharacteristicName = characteristicName3
        let characteristic2b = Characteristic (context:context)
        characteristic2b.x = 0.2
        characteristic2b.y = 0.2
        characteristic2b.z = 0.2
        characteristic2b.toCharacteristicName = characteristicName3
        let characteristic3b = Characteristic (context:context)
        characteristic3b.x = 0.3
        characteristic3b.y = 0.3
        characteristic3b.z = 0.3
        characteristic3b.toCharacteristicName = characteristicName3
        
        
        let sensorData1 = SensorData(context: context)
        sensorData1.timeStamp = NSDate()
        sensorData1.addToToCharacteristic(characteristic1)
        sensorData1.addToToCharacteristic(characteristic2)
        sensorData1.addToToCharacteristic(characteristic3)
        
        let sensorData2 = SensorData(context: context)
        sensorData2.timeStamp = NSDate()
        sensorData2.addToToCharacteristic(characteristic1a)
        sensorData2.addToToCharacteristic(characteristic2a)
        sensorData2.addToToCharacteristic(characteristic3a)
        
        let sensorData3 = SensorData(context: context)
        sensorData3.timeStamp = NSDate()
        sensorData3.addToToCharacteristic(characteristic1b)
        sensorData3.addToToCharacteristic(characteristic2b)
        sensorData3.addToToCharacteristic(characteristic3b)
        
        
        let session1 = Session(context: context)
        session1.id = 1
        session1.duration = "00:10"
        session1.date = NSDate()
        session1.frequency = 100
        session1.addToToSensorData(sensorData1)
        session1.addToToSensorData(sensorData2)
        session1.addToToSensorData(sensorData3)
        
        let session2 = Session(context: context)
        session2.id = 2
        session2.duration = "00:15"
        session2.date = NSDate()
        session2.frequency = 100
        session2.addToToSensorData(sensorData1)
        session2.addToToSensorData(sensorData2)
        session2.addToToSensorData(sensorData3)
        
        
        ad.saveContext()
    }
    
    
    
    //  MARK - Fetching and adding data to data model for local usage
    
    func findLastSessionId() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        fetchRequest.fetchLimit = 1
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let record = try context.fetch(fetchRequest) as! [Session]
            
            if record.count == 1 {
                let lastSession = record.first! as Session
                nextSessionid = Int(lastSession.id) + 1
                settingsTableVC?.currentRecordNumberLabel.text = "\(nextSessionid)"
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func addNamesOfCharacteristics(){
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacteristicName")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let records = try context.fetch(fetchRequest) as! [CharacteristicName]
            
            if records.count != 3 {
                let characteristicName1 = CharacteristicName (context:context)
                characteristicName1.name = "Gyro"
                let characteristicName2 = CharacteristicName (context:context)
                characteristicName2.name = "Acc"
                let characteristicName3 = CharacteristicName (context:context)
                characteristicName3.name = "Mag"
                ad.saveContext()
            }
            
        } catch {
            print(error)
        }
        
        // Populate local array
        let fetchRequestForLocalCharacteristicName: NSFetchRequest<CharacteristicName> = CharacteristicName.fetchRequest()
        let sortDescriptorForLocalCharacteristicName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequestForLocalCharacteristicName.sortDescriptors = [sortDescriptorForLocalCharacteristicName]
        do {
            self.characteristicsNames = try context.fetch(fetchRequestForLocalCharacteristicName)
        }   catch   {
            print(error)
        }
        
    }
    
    func addSensorIDs(){
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let records = try context.fetch(fetchRequest) as! [Sensor]
            
            if records.count != 2 {
                let sensor1 = Sensor(context: context)
                sensor1.id = 1
                let sensor2 = Sensor(context: context)
                sensor2.id = 2
                
                ad.saveContext()
            }
            
        } catch {
            print(error)
        }
        
        // Populate local array
        let fetchRequestForLocalSensors: NSFetchRequest<Sensor> = Sensor.fetchRequest()
        let sortDescriptorForLocalSensors = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestForLocalSensors.sortDescriptors = [sortDescriptorForLocalSensors]
        do {
            self.sensors = try context.fetch(fetchRequestForLocalSensors)
        }   catch   {
            print(error)
        }
        
    }
    
    
    
    // MARK - Work with WCSessionDelegate
    
    // for receiving sessions
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        
        print ("File with data received on iPhone!")
        
        let fm = FileManager.default
        let destURL = getDocumentsDirectory().appendingPathComponent("saved_file")
        
        do {
            if fm.fileExists(atPath: destURL.path) {
                
                // the file already exists - delete it
                try fm.removeItem (at: destURL)
            }
            
            // copy the file for its temporary location
            try fm.copyItem(at: file.fileURL, to: destURL)
            
            // load the file and print it out
            let mutableData = NSMutableData(contentsOf: destURL)
            
            let data = mutableData?.copy() as! Data
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            do {
                if let sessionContainerCopy = try unarchiver.decodeTopLevelDecodable(SessionContainer.self, forKey: NSKeyedArchiveRootObjectKey) {
                    // print("deserialized sensor output: \(String(describing: sessionContainerCopy.currentFrequency))")
                    
                    // work with received data
                    
                    sensorWatchOutputs = sessionContainerCopy.sensorOutputs
                    if (self.sessionType == SessionType.PhoneAndWatch) {
                        
                        for sensorOutput in self.sensorWatchOutputs {
                            
                            let characteristicGyro = Characteristic (context:context)
                            characteristicGyro.x = sensorOutput.gyroX!
                            characteristicGyro.y = sensorOutput.gyroY!
                            characteristicGyro.z = sensorOutput.gyroZ!
                            characteristicGyro.toCharacteristicName = self.characteristicsNames[1]
                            
                            let characteristicAcc = Characteristic (context:context)
                            characteristicAcc.x = sensorOutput.accX!
                            characteristicAcc.y = sensorOutput.accY!
                            characteristicAcc.z = sensorOutput.accZ!
                            characteristicAcc.toCharacteristicName = self.characteristicsNames[0]
                            
                            
                            let sensorData = SensorData(context: context)
                            sensorData.timeStamp = sensorOutput.timeStamp as NSDate?
                            sensorData.toSensor = sensors[1]
                            sensorData.addToToCharacteristic(characteristicGyro)
                            sensorData.addToToCharacteristic(characteristicAcc)
                            
                            self.currentSession?.addToToSensorData(sensorData)
                        }
                        self.sensorWatchOutputs.removeAll()
                        
                        ad.saveContext()
                        self.currentSession = nil
                        self.sessionType = SessionType.OnlyPhone
                    }
                    
                }
            } catch {
                print("unarchiving failure: \(error)")
            }
        }
            
        catch {
            // something went wrong
            print ("File copy failed")
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // for receiving signals to start recording
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            
            if let isAlsoRun = message["Running"] as? Bool {
                
                if (isAlsoRun) {
                    self.sessionType = SessionType.PhoneAndWatch
                    self.StartButtonpressed((Any).self)
                    
                    if let recID = message["RecordID"] as? Int {
                        self.currentSession?.recordID = Int32(recID)
                        self.settingsTableVC?.recordID.text = "\(recID)"
                    }
                    
                    // send back reply
                    replyHandler(["response": "Starting collecting data..."])
                    
                } else {
                    self.stopButtonPressed((Any).self)
                    
                    // send back reply
                    replyHandler(["response": "Stopping collecting data..."])
                }
                
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.sync {
            if activationState == .activated {
                if session.isWatchAppInstalled {
                    print ("Watch app is installed")
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
