//
//  BreathStepsView.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import SwiftUI

struct BreathStepsView: View {
    @EnvironmentObject private var home: WorkoutsViewModel
    
    let workout: BreathWorkout
    @State private var isEditing: EditMode = .inactive
    
    private var steps: [BreathStep]{
        if let steps =  workout.breathSteps?.allObjects as? [BreathStep]{
            return steps.sorted { $0.sortOrder < $1.sortOrder
            }
        }else {return []}
    }
    
    var body: some View {
        
        VStack{
            List{
                ForEach(steps ){ step in
               //     Text(step.breathType?.rawValue.capitalized ?? "")
                    
                    StepListItem(breathStep: step)
                }
                .onDelete(perform: { offsets in
                    home.deleteStepAtOffsets(offsets, steps: steps)
                })
                .onMove{ offsets, destination in
                    home.moveStepsFromOffsets(offsets, to: destination ,steps: steps)
                }
                .listRowInsets(EdgeInsets())
                }
            .listStyle(.plain)
            }
        .toolbar{
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                
                Button {
                    // add a step
                    withAnimation {
                        home.addStepToWorkout(workout)
                    }
                    
                }label: {
                    Image(systemName: "plus")
                }
                
                
            }
        }
        .environment(\.editMode, $isEditing)
            
        
        
    }
}

#Preview {
    NavigationView {
        BreathStepsView(workout: BreathWorkout.example)
            .environmentObject(WorkoutsViewModel(useMemoryStore: true))
            .navigationTitle(BreathWorkout.example.title ?? "")
    }
   
    
}
