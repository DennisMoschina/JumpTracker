//
//  ContentView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var motionViewModel: MotionViewModel
    @ObservedObject var recordingViewModel: MotionRecorderViewModel
    
    var body: some View {
        VStack {
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
                    recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
