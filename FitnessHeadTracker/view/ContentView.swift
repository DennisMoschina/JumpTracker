//
//  ContentView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var motionViewModel: MotionViewModel
    @ObservedObject var distanceTrackerViewModel: DistanceTrackerViewModel
    @ObservedObject var speedViewModel: SpeedViewModel
    @ObservedObject var recordingViewModel: MotionRecorderViewModel
    
    var body: some View {
        VStack {
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
            .buttonStyle(.bordered)
            .tint(.red)

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
            
            
            HeadingView(motionViewModel: self.motionViewModel)
            
            Spacer()
            
            Toggle("Record when monitoring", isOn: self.$recordingViewModel.startOnMonitor)
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            
            ManageMonitoringButton(viewModel: self.motionViewModel)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let motionManager: any MotionManagerProtocol = MotionManagerMock()
    static var previews: some View {
        ContentView(motionViewModel: MotionViewModel(motionManager: motionManager),
                    distanceTrackerViewModel: DistanceTrackerViewModel(distanceTracker: MotionBasedDistanceTracker(motionManager: motionManager)),
                    speedViewModel: SpeedViewModel(speedCalculator: MotionBasedSpeedCalculator(motionManager: motionManager)),
                    recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
