//
//  AddWorkoutSheet.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import SwiftUI

protocol AddWorkoutDelegate{
    
    func addWorkoutWithTitle(_ title: String, andSteps steps: Int)
}

struct AddWorkoutSheet: View {
    @State private var titleText: String = ""
    @State private var numberOfSteps: Int = 1
    
    @Binding  var isShowingSheet: Bool
    
    var delegate: AddWorkoutDelegate
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20.0){
            
            //toolbar
            HStack{
                
                Button("Cancel") {
                    //dismiss
                    isShowingSheet  = false
                }
                
                Spacer()
                
                Text("Add Workout").fontWeight(.medium)
                
                Spacer()
                
                Button("Add") {
                    //dismiss
                    isShowingSheet = false
                    
                    //create a workout with title and num of steps
                    delegate.addWorkoutWithTitle(titleText, andSteps: numberOfSteps)
                }
                
                }
            
            Text("What is thename of the workout")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            //title-question
            //text field- title input
            TextField("Add workout", text: $titleText, prompt: Text("Yoga"))
                .padding()
                .background(
                    Rectangle().stroke()
                )
            
            //stepper number of steps
            
            Stepper("Number of steps: \(numberOfSteps)", value: $numberOfSteps, in: 1...4)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddWorkoutSheet(isShowingSheet: Binding.constant(true), delegate: WorkoutsViewModel(useMemoryStore: true))
}
