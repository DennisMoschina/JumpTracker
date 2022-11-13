//
//  FitnessHeadTrackerApp.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

@main
struct FitnessHeadTrackerApp: App {
    let persistenceController = PersistenceController.shared
    let recorder = MotionCoreDataRecorder()
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
        }
        .onChange(of: self.scenePhase) { newValue in
            self.persistenceController.save()
        }
    }
}
