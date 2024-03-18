//
//  BWPacerApp.swift
//  BWPacer
//
//  Created by Franklin on 6/4/2022.
//

import SwiftUI

@main
struct BWPacerApp: App {
    
   // @StateObject private var storageProvider = StorageProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeWorkoutsView()
                
                .environmentObject(WorkoutsViewModel())
        }
    }
}
