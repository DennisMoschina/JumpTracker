//
//  HomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Environment(\.persistenceController) var persistenceController
    
    var body: some View {
        Group {
            let dataRecorder = DataRecorder(persistenceController: self.persistenceController)
            let motionViewModel = MotionViewModel(motionManager: MotionManager.singleton)
            let motionRecorder = MotionCoreDataRecorder(dataRecorder: dataRecorder)
            let hipPositionRecorder = HipPositionRecorder(dataRecorder: dataRecorder)
            let recorderViewModel = MotionRecorderViewModel(motionRecorder: motionRecorder, hipPositionRecorder: hipPositionRecorder, dataRecorder: dataRecorder)
            
            switch self.horizontalSizeClass {
            case .compact:
                CompactHomeView(motionViewModel: motionViewModel, recordingViewModel: recorderViewModel)
            case .regular:
                RegularHomeView(motionViewModel: motionViewModel, recordingViewModel: recorderViewModel)
            default:
                Text("something really weird happened")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
