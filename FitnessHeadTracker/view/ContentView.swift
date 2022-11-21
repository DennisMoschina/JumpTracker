//
//  ContentView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var motionViewModel = MotionViewModel(motionManager: FilteredMotionManager(motionManager: MotionManager.singleton, accelFilterX: DeadBandFilter(deadBand: 0.008), accelFilterY: EwmaFilter(alpha: 0.3), accelFilterZ: EwmaFilter(alpha: 0.3)))
    @ObservedObject var distanceTrackerViewModel = MotionBasedDistanceTracker(motionManager: MotionManager.singleton)
    @ObservedObject var speedViewModel: SpeedViewModel = SpeedViewModel(speedCalculator: MotionBasedSpeedCalculator(motionManager: MotionManager.singleton))
    @ObservedObject var recordingViewModel: MotionRecorderViewModel = MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder())
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    RecordingsListView()
                } label: {
                    Text("Recordings")
                }
                
                HStack {
                    Text("Current Speed")
                    Text("\(self.speedViewModel.speed.x, specifier: "%.2f")")
                    Text("\(self.speedViewModel.speed.y, specifier: "%.2f")")
                    Text("\(self.speedViewModel.speed.z, specifier: "%.2f")")
                }
                HStack {
                    Text("Distance travelled")
                    Text("\(self.distanceTrackerViewModel.distance.x, specifier: "%.2f")")
                    Text("\(self.distanceTrackerViewModel.distance.y, specifier: "%.2f")")
                    Text("\(self.distanceTrackerViewModel.distance.z, specifier: "%.2f")")
                }
                Button {
                    self.distanceTrackerViewModel.reset()
                    self.speedViewModel.reset()
                } label: {
                    Text("Reset")
                }

                HStack {
                    Text("Acceleration")
                    Text("\(motionViewModel.userAcceleration.x, specifier: "%.2f")")
                    Text("\(motionViewModel.userAcceleration.y, specifier: "%.2f")")
                    Text("\(motionViewModel.userAcceleration.z, specifier: "%.2f")")
                }
                HStack {
                    Text("RotationRate")
                    Text("\(motionViewModel.rotationRate.x, specifier: "%.2f")")
                    Text("\(motionViewModel.rotationRate.y, specifier: "%.2f")")
                    Text("\(motionViewModel.rotationRate.z, specifier: "%.2f")")
                }
                
                Button {
                    self.recordingViewModel.startRecording()
                    self.motionViewModel.startMonitoring()
                } label: {
                    Text("Start Motion Monitoring")
                }
                
                Button {
                    self.motionViewModel.stopMonitoring()
                    self.recordingViewModel.endRecording()
                } label: {
                    Text("Stop")
                }
                
                HeadingView(motionViewModel: self.motionViewModel)
                
                AccelerationChart(motionViewModel: self.motionViewModel)
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
