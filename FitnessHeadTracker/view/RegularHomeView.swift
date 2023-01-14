//
//  RegularHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

enum MainNavigation: Int, CaseIterable {
    case current
    case attitude
    case recordingsList
    case bluetooth
    
    var description: String {
        switch (self) {
        case .current:
            return "Current Values"
        case .attitude:
            return "Attitude"
        case .recordingsList:
            return "Recordings"
        case .bluetooth:
            return "Bluetooth"
        }
    }
    var imageName: String {
        switch (self) {
        case .current:
            return "display"
        case .attitude:
            return "circle.and.line.horizontal"
        case .recordingsList:
            return "recordingtape"
        case .bluetooth:
            return "airpodspro.chargingcase.wireless"
        }
    }
}

struct RegularHomeView: View {
    private var motionViewModel: MotionViewModel = MotionViewModel(motionManager: MotionManager.singleton)
    private var distanceTrackerViewModel: DistanceTrackerViewModel = DistanceTrackerViewModel(distanceTracker: MotionBasedDistanceTracker(motionManager: MotionManager.singleton))
    private var speedViewModel: SpeedViewModel = SpeedViewModel(speedCalculator: MotionBasedSpeedCalculator(motionManager: MotionManager.singleton))
    private var recordingViewModel: MotionRecorderViewModel = MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder())
    
    @State var selectedNavigation: MainNavigation = MainNavigation.current
    
    var body: some View {
        NavigationSplitView {
            List(MainNavigation.allCases, id: \.rawValue) { nav in
                Button {
                    self.selectedNavigation = nav
                } label: {
                    Label(nav.description, systemImage: nav.imageName)
                }
            }
        } detail: {
            switch self.selectedNavigation {
            case .current:
                ContentView(motionViewModel: self.motionViewModel,
                            distanceTrackerViewModel: self.distanceTrackerViewModel,
                            speedViewModel: self.speedViewModel,
                            recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
            case .attitude:
                AttitudeIndicator(motionViewModel: self.motionViewModel)
            case .recordingsList:
                RecordingsListView()
            case .bluetooth:
                DistanceView(distanceTrackerViewModel: AbsoluteDistanceTrackerViewModel(trackerFactory: RSSIBasedAbsoluteDistanceTrackerFactory(bleManager: BLEManager.Singleton)))
            }
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
