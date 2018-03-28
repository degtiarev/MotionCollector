//
//  Sensor+CoreDataProperties.swift
//  DataCollector
//
//  Created by Aleksei Degtiarev on 27/02/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//
//

import Foundation
import CoreData


extension Sensor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sensor> {
        return NSFetchRequest<Sensor>(entityName: "Sensor")
    }

    @NSManaged public var id: Int32
    @NSManaged public var toSensorData: NSSet?

}

// MARK: Generated accessors for toSensorData
extension Sensor {

    @objc(addToSensorDataObject:)
    @NSManaged public func addToToSensorData(_ value: SensorData)

    @objc(removeToSensorDataObject:)
    @NSManaged public func removeFromToSensorData(_ value: SensorData)

    @objc(addToSensorData:)
    @NSManaged public func addToToSensorData(_ values: NSSet)

    @objc(removeToSensorData:)
    @NSManaged public func removeFromToSensorData(_ values: NSSet)

}
