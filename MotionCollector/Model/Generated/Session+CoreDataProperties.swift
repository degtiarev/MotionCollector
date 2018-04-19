//
//  Session+CoreDataProperties.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 19/04/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var duration: String?
    @NSManaged public var frequency: Int32
    @NSManaged public var id: Int32
    @NSManaged public var recordID: Int32
    @NSManaged public var type: Int32
    @NSManaged public var toSensorData: NSSet?

}

// MARK: Generated accessors for toSensorData
extension Session {

    @objc(addToSensorDataObject:)
    @NSManaged public func addToToSensorData(_ value: SensorData)

    @objc(removeToSensorDataObject:)
    @NSManaged public func removeFromToSensorData(_ value: SensorData)

    @objc(addToSensorData:)
    @NSManaged public func addToToSensorData(_ values: NSSet)

    @objc(removeToSensorData:)
    @NSManaged public func removeFromToSensorData(_ values: NSSet)

}
