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
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeView()
               .environment(\.persistenceController, self.persistenceController)
        }
        .onChange(of: self.scenePhase) { newValue in
            self.persistenceController.save()
        }
    }
}
