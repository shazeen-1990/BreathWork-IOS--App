//
//  StorageProvider.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import Foundation
import CoreData

class StorageProvider: ObservableObject{
    
    //PC
    let persistentContainer: NSPersistentContainer
    
    private var viewContext: NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    var onUpdateAction: (()->Void)?
    
    static let shared = StorageProvider()
    
    static let preview: StorageProvider = {
        let storageProvider = StorageProvider(inMemory: true)
        
        let viewContext = storageProvider.persistentContainer.viewContext
        
        
        let breathWorkout = BreathWorkout(context: viewContext)
        
        breathWorkout.id = UUID()
        breathWorkout.title = "Mock Workout"
        
            
///create step func
        
      
        
        let inhale = storageProvider.createStep(sortOrder: 0, duration: 6.0, breathType: .inhale)
        
        let rest = storageProvider.createStep(sortOrder: 1, duration: 2.0, breathType: .rest)
        
        let exhale = storageProvider.createStep(sortOrder: 2, duration: 4.0, breathType: .exhale)
        
        breathWorkout.addToBreathSteps(inhale)
        breathWorkout.addToBreathSteps(rest)
        breathWorkout.addToBreathSteps(exhale)
        
        storageProvider.workouts = storageProvider.getAllWorkouts()
        
        try? viewContext.save()
        
        return storageProvider
    }()
    
    
    @Published private(set) var workouts: [BreathWorkout] = []
    
    private init(inMemory: Bool = false){
        persistentContainer = NSPersistentContainer(name: "BWPacer")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        //load
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load the store.Error: \(error)")
            }else{
                print("successfully loaded the store")
                
                //fetching the workouts
                self.workouts = self.getAllWorkouts()
                //dump(self.workouts)
            }
        }
    }
    
    private func getAllWorkouts()->[BreathWorkout]{
        
        let request = BreathWorkout.fetchRequest()
//if need we can use sort descropt /predicates.but not using here
        do{
            return try persistentContainer.viewContext.fetch(request)
        }catch{
            
        }
        
        return []
    }
    
    func createWorkoutWithTitle(_ title: String, andSteps steps: Int) {
        let workout = BreathWorkout(context: viewContext)
        workout.id = UUID()
        workout.title = title
        
        for i in 0..<steps {
            //create step
            let step = createStep(sortOrder: i, duration: 3.0, breathType: .inhale)
            workout.addToBreathSteps(step)
        }
        
        //save
        save {
            print("Workout Added: \(workout.title ?? "")")
        }
    }
    
     func createStep(sortOrder:Int, duration: Double, breathType: BreathType) -> BreathStep {
        //create steps
        let step = BreathStep(context: viewContext)
        step.id = UUID()
        step.sortOrder = Int64(sortOrder)
        step.duration = 4.0
        step.breathType = breathType
        //step.breathWorkout = breathWorkout
        return step
    }
    
     func save(onSaveAction: (() -> Void)? = nil){
        do{
            try viewContext.save()
            self.workouts = getAllWorkouts()
            if let onSaveAction = onSaveAction{
                onSaveAction()
                if let onUpdateAction = onUpdateAction{onUpdateAction()}
            }
        }catch{
            print(error)
        }
    }
    
    func deleteEntity<Entity: NSManagedObject>(_ entity: Entity){
        
       // let title = workout.title ?? ""
        viewContext.delete(entity)
        save{
            print("deleted object")
        }
    }
}
