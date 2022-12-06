//
//  CompactHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//
//

import SwiftUI

struct CompactHomeView: View {
    private var motionViewModel: MotionViewModel = MotionViewModel(motionManager: MotionManager.singleton)
    private var distanceTrackerViewModel: DistanceTrackerViewModel = DistanceTrackerViewModel(distanceTracker: MotionBasedDistanceTracker(motionManager: MotionManager.singleton))
    private var speedViewModel: SpeedViewModel = SpeedViewModel(speedCalculator: MotionBasedSpeedCalculator(motionManager: MotionManager.singleton))
    private var recordingViewModel: MotionRecorderViewModel = MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder())
    
    
    var body: some View {
        NavigationView {
            TabView {
                ContentView(motionViewModel: self.motionViewModel,
                            distanceTrackerViewModel: self.distanceTrackerViewModel,
                            speedViewModel: self.speedViewModel,
                            recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
                    .tabItem {
                        Label("Current", systemImage: "play")
                    }
                
                AttitudeIndicator(motionViewModel: self.motionViewModel)
                    .tabItem {
                        Label("Attitude", systemImage: "circle.and.line.horizontal")
                    }
                
                RecordingsListView()
                    .tabItem {
                        Label("Recordings", systemImage: "recordingtape")
                    }
            }
        }
    }
}

struct CompactHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CompactHomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
