//
//  RegularHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

enum MainNavigation: Int, CaseIterable {
    case current
    case charts
    case recordingsList
    
    var description: String {
        switch (self) {
        case .current:
            return "Current Values"
        case .charts:
            return "Charts"
        case .recordingsList:
            return "Recordings"
        }
    }
    var imageName: String {
        switch (self) {
        case .current:
            return "display"
        case .charts:
            return "chart.xyaxis.line"
        case .recordingsList:
            return "recordingtape"
        }
    }
}

struct RegularHomeView: View {
    var motionViewModel: MotionViewModel
    var recordingViewModel: MotionRecorderViewModel
    
    @State var selectedNavigation: MainNavigation = MainNavigation.current
    
    @Environment(\.persistenceController) var persistenceController
    
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
                            recordingViewModel: self.recordingViewModel)
            case.charts:
                ValuesView(viewModel: self.motionViewModel)
            case .recordingsList:
                RecordingsListView()
                    .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
            }
        }
    }
}

struct RegularHomeView_Previews: PreviewProvider {
    static let motionManager: any MotionManagerProtocol = MotionManagerMock()
    static let dataRecorder: DataRecorder = DataRecorder(persistenceController: PersistenceController.preview)
    
    static var previews: some View {
        RegularHomeView(motionViewModel: MotionViewModel(motionManager: motionManager), recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder(dataRecorder: dataRecorder), hipPositionRecorder: HipPositionRecorder(dataRecorder: dataRecorder), dataRecorder: dataRecorder))
            .environment(\.persistenceController, PersistenceController.preview)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
    }
}
