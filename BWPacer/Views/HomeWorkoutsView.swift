//
//  HomeWorkoutsView.swift
//  BWPacer
//
//  Created by Shazeen Thowfeek on 15/03/2024.
//

import SwiftUI

struct HomeWorkoutsView: View {
    
    @EnvironmentObject private var home: WorkoutsViewModel
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(home.workouts){ workout in
                    
                    let title = workout.title ?? "No title"
                    
                    NavigationLink(title) {
                        BreathStepsView(workout: workout)
                            .navigationTitle(title)
                    }
                    
                   
                }
                .onDelete(perform: home.deleteWorkouts)
            }
            .navigationTitle("Your workouts")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // present the shet
                        isShowingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .sheet(isPresented: $isShowingSheet, content: {
                        AddWorkoutSheet(isShowingSheet: $isShowingSheet, delegate: home)
                    })
                }
            }
        }
    }
}

#Preview {
    HomeWorkoutsView()
        .environmentObject(WorkoutsViewModel(useMemoryStore: true))
}
