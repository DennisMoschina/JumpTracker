//
//  RegularHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

struct RegularHomeView: View {
    private var motionViewModel: MotionViewModel = MotionViewModel(motionManager: MotionManager.singleton)
    private var distanceTrackerViewModel: DistanceTrackerViewModel = DistanceTrackerViewModel(distanceTracker: MotionBasedDistanceTracker(motionManager: MotionManager.singleton))
    private var speedViewModel: SpeedViewModel = SpeedViewModel(speedCalculator: MotionBasedSpeedCalculator(motionManager: MotionManager.singleton))
    private var recordingViewModel: MotionRecorderViewModel = MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder())
    
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ContentView(motionViewModel: self.motionViewModel,
                                distanceTrackerViewModel: self.distanceTrackerViewModel,
                                speedViewModel: self.speedViewModel,
                                recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
                } label: {
                    Label("Current Values", systemImage: "display")
                }
                NavigationLink {
                    RecordingsListView()
                } label: {
                    Label("Recordings", systemImage: "recordingtape")
                }

            }.listStyle(.sidebar)
            
            ContentView(motionViewModel: self.motionViewModel,
                        distanceTrackerViewModel: self.distanceTrackerViewModel,
                        speedViewModel: self.speedViewModel,
                        recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
        }
    }
}

struct RegularHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RegularHomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
    }
}
