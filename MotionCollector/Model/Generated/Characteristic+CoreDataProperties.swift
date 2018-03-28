//
//  Characteristic+CoreDataProperties.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 05/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//
//

import Foundation
import CoreData


extension Characteristic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Characteristic> {
        return NSFetchRequest<Characteristic>(entityName: "Characteristic")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var toCharacteristicName: CharacteristicName?
    @NSManaged public var toSensorData: SensorData?

}
