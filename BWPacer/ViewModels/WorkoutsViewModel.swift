//
//  WorkoutsViewModel.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import Foundation

class WorkoutsViewModel: ObservableObject,AddWorkoutDelegate{
    
    
    private let storageProvider: StorageProvider
    
    @Published private(set) var workouts: [BreathWorkout]
    
    //var workouts: [BreathWorkout]{storageProvider.workouts}
    
    init(useMemoryStore: Bool = false) {
        self.storageProvider = useMemoryStore ? StorageProvider.preview : StorageProvider.shared
        self.workouts = self.storageProvider.workouts
        self.storageProvider.onUpdateAction = {self.workouts = self.storageProvider.workouts}
    }
    
    func addWorkoutWithTitle(_ title: String, andSteps steps: Int) {
        // call t ostorage provider to add workouts
        
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "Workout \(workouts.count)" : title
        storageProvider.createWorkoutWithTitle(title, andSteps: steps)
      //  objectWillChange.send()
        
    }
    
//    func fetchWorkouts(){
//        self.workouts = self.storageProvider.workouts
//    }
    
    func deleteWorkouts(at offsets: IndexSet){
        
        //1.map the index to the item in our workout
        offsets.map { workouts[$0]}.forEach{storageProvider.deleteEntity($0)}
        //2.call delete in the storage provider
        //storageProvider.deleteWorkout(workout)
        
    }
    
    func deleteStepAtOffsets(_ offsets: IndexSet, steps: [BreathStep]){
        offsets.map { steps[$0]}.forEach{storageProvider.deleteEntity($0)}
    }
    
//    func deleteEntityAtOffsets<Entity: NSManagedObject>(_ offsets: IndexSet, items: [Entity]){
//        offsets.map { items[$0]}.forEach{storageProvider.deleteEntity($0)}
//    }
//    
    func moveStepsFromOffsets(_ offsets: IndexSet, to destination: Int ,steps: [BreathStep]){
        offsets.forEach { print("startindex:\($0), Destination: \(destination)")}
        
        let startIndex = offsets.first!
        
        guard startIndex != destination else{return}
        
        let targetIndex = destination > startIndex ? destination - 1 : destination
        
        var steps = steps
        let movedStep = steps.remove(at: startIndex)
        steps.insert(movedStep, at: targetIndex) // array  that reflect our view
        
        let  _ = steps.indices.map { steps[$0].sortOrder = Int64($0)}
        
        //save
        
        storageProvider.save{
            print("Moved step from \(startIndex) to \(targetIndex)")
        }
    }
    
    func addStepToWorkout(_ workout: BreathWorkout){
        let step = storageProvider.createStep(sortOrder: workout.breathSteps?.count ?? 0, duration: 3.0, breathType: .inhale)
        
        workout.addToBreathSteps(step)
        
        storageProvider.save {
            print("Breath Step added")
        }
    }
    
    func updateBreathType(_ selectedType: BreathType,on breathStep: BreathStep){
        breathStep.breathType = selectedType
        
        storageProvider.save {
            print("Changed step type to \(selectedType.rawValue)")
        }
    }
    
    func updateDuration(_ duration: Double, on breathStep : BreathStep){
        breathStep.duration = duration
        
        storageProvider.save{
            print("Changed duration to \(duration)")
        }
    }
    
}
