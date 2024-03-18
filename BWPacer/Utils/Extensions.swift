//
//  Extensions.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import Foundation

extension BreathWorkout{
    static var example: BreathWorkout{
        
        let fetchRequest = BreathWorkout.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let viewContext = StorageProvider.preview.persistentContainer.viewContext
        
        return try! viewContext.fetch(fetchRequest).first!
    }
}
