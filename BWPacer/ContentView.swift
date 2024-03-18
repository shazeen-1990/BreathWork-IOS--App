//
//  ContentView.swift
//  BWPacer
//
//  Created by Franklin on 6/4/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var storageProvider: StorageProvider
    
    var body: some View {
        List(storageProvider.workouts){ workout in
            Text(workout.title ?? "Not Avaailable")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StorageProvider.preview)
    }
}
