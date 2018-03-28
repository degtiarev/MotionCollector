//
//  CharacteristicName+CoreDataProperties.swift
//  MotionCollector
//
//  Created by Aleksei Degtiarev on 05/03/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//
//

import Foundation
import CoreData


extension CharacteristicName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacteristicName> {
        return NSFetchRequest<CharacteristicName>(entityName: "CharacteristicName")
    }

    @NSManaged public var name: String?
    @NSManaged public var toCharacteristic: NSSet?

}

// MARK: Generated accessors for toCharacteristic
extension CharacteristicName {

    @objc(addToCharacteristicObject:)
    @NSManaged public func addToToCharacteristic(_ value: Characteristic)

    @objc(removeToCharacteristicObject:)
    @NSManaged public func removeFromToCharacteristic(_ value: Characteristic)

    @objc(addToCharacteristic:)
    @NSManaged public func addToToCharacteristic(_ values: NSSet)

    @objc(removeToCharacteristic:)
    @NSManaged public func removeFromToCharacteristic(_ values: NSSet)

}
