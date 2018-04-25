//
//  SensorData+CoreDataProperties.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 24/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//
//

import Foundation
import CoreData


extension SensorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorData> {
        return NSFetchRequest<SensorData>(entityName: "SensorData")
    }

    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var toCharacteristic: NSSet?
    @NSManaged public var toSensor: Sensor?
    @NSManaged public var toSession: Session?

}

// MARK: Generated accessors for toCharacteristic
extension SensorData {

    @objc(addToCharacteristicObject:)
    @NSManaged public func addToToCharacteristic(_ value: Characteristic)

    @objc(removeToCharacteristicObject:)
    @NSManaged public func removeFromToCharacteristic(_ value: Characteristic)

    @objc(addToCharacteristic:)
    @NSManaged public func addToToCharacteristic(_ values: NSSet)

    @objc(removeToCharacteristic:)
    @NSManaged public func removeFromToCharacteristic(_ values: NSSet)

}
