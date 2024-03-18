//
//  StepListItem.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 18/03/2024.
//

import SwiftUI

struct StepListItem: View {
    
    @EnvironmentObject private var home: WorkoutsViewModel
    
    let breathStep: BreathStep
    @State private var selectedType: BreathType = .inhale
    @State private var duration: Double = 3.0
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 40.0){
            
            //segmented control breath type
            Picker("Breath Type", selection: $selectedType) {
                ForEach(BreathType.allCases, id: \.self){breathType in
                    Text(breathType.rawValue.capitalized)
                        .tag(breathType)
                    
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedType) { newValue in
                // call the view model with the user intent
                
                //change the breath type
                
                home.updateBreathType(selectedType,on: breathStep)
            }
            
            //stepper control for the duration
            Stepper("Duration: \(duration)", value: $duration, step: 0.1)
                .onChange(of: duration) { newValue in
                    home.updateDuration(duration, on: breathStep)
                }
        
        }
        .padding()
        .background(getTintColourforBreathType(breathStep.breathType))
        .onAppear{
            self.selectedType = breathStep.breathType ?? .inhale
            self.duration = breathStep.duration
        }
        
    }
    private func getTintColourforBreathType(_ breathType: BreathType?)-> Color{
        
        switch breathType {
        case .inhale:
            return .pink
        case .exhale:
            return .purple
        case .rest:
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    StepListItem(breathStep: BreathStep.example)
        .environmentObject(WorkoutsViewModel(useMemoryStore: true))
}

extension BreathStep{
    static var example: BreathStep{
        
        let fetchRequest = BreathStep.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let viewContext = StorageProvider.preview.persistentContainer.viewContext
        
        return try! viewContext.fetch(fetchRequest).first!
    }
}
