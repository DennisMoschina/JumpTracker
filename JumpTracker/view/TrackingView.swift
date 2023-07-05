//
//  ContentView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

struct TrackingView: View {
    @ObservedObject var motionViewModel: MotionViewModel
    @ObservedObject var recordingViewModel: MotionRecorderViewModel
    
    var body: some View {
        VStack {
            ARViewContainer(onSkeletonCreate: { skeleton in
                self.recordingViewModel.hipPositionRecorder.bodySkeleton = skeleton
            })
                .edgesIgnoringSafeArea(.all)

            ManageMonitoringButton(viewModel: self.motionViewModel, recordingViewModel: self.recordingViewModel)
            
            Spacer()
        }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static let motionManager: any MotionManagerProtocol = MotionManagerMock()
    static let dataRecorder = DataRecorder(persistenceController: PersistenceController.preview)
    
    static var previews: some View {
        TrackingView(motionViewModel: MotionViewModel(motionManager: motionManager),
                    recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder(dataRecorder: dataRecorder),
                                                                hipPositionRecorder: HipPositionRecorder(dataRecorder: dataRecorder),
                                                                dataRecorder: dataRecorder))
    }
}
