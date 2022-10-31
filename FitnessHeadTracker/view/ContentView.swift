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
    
    var body: some View {
        VStack {
            HStack {
                Text("Distance travelled")
                Text("\(self.distanceTrackerViewModel.distance.x, specifier: "%.2f")")
                Text("\(self.distanceTrackerViewModel.distance.y, specifier: "%.2f")")
                Text("\(self.distanceTrackerViewModel.distance.z, specifier: "%.2f")")
            }
            Button {
                self.distanceTrackerViewModel.reset()
            } label: {
                Text("Reset distance")
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
                self.motionViewModel.startMonitoring()
            } label: {
                Text("Start Motion Monitoring")
            }
            
            Button {
                self.motionViewModel.stopMonitoring()
            } label: {
                Text("Stop")
            }
            
            Spacer()
            
            AccelerationChart(motionViewModel: self.motionViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
