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
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)

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
