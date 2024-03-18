//
//  BreathStep+CoreDataProperties.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//
//

import Foundation
import CoreData


extension BreathStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreathStep> {
        return NSFetchRequest<BreathStep>(entityName: "BreathStep")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sortOrder: Int64
    @NSManaged private var breathTypeValue: String?
    @NSManaged public var duration: Double
    @NSManaged public var breathWorkout: BreathWorkout?

}

extension BreathStep : Identifiable {
    var breathType: BreathType?{
        get{
            guard let breathTypeValue = self.breathTypeValue else { return nil}
            
            return  BreathType(rawValue: breathTypeValue)
        }
        
        set{
            self.breathTypeValue = newValue?.rawValue
        }
    }
}

enum BreathType: String,CaseIterable {
    case inhale, exhale,rest
}
