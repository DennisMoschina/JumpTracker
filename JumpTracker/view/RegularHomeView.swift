//
//  RegularHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

enum MainNavigation: Int, CaseIterable, Identifiable {
    case current
    case charts
    case recordingsList
    case jumpAnalysis
    
    var id: Int {
        self.rawValue
    }

    var description: String {
        switch (self) {
        case .current:
            return "Current Values"
        case .charts:
            return "Charts"
        case .recordingsList:
            return "Recordings"
        case .jumpAnalysis:
            return "Jump Analysis"
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
        case .jumpAnalysis:
            return "waveform.and.magnifyingglass"
        }
    }
}

struct RegularHomeView: View {
    var motionViewModel: MotionViewModel
    var recordingViewModel: MotionRecorderViewModel
    
    @State var selectedNavigation: MainNavigation? = MainNavigation.current
    
    @Environment(\.persistenceController) var persistenceController
    
    var body: some View {
        NavigationSplitView {
            List(MainNavigation.allCases, selection: self.$selectedNavigation) { nav in
                NavigationLink(value: nav) {
                    Label(nav.description, systemImage: nav.imageName)
                }
            }
        } detail: {
            switch self.selectedNavigation {
            case .current:
                TrackingView(motionViewModel: self.motionViewModel,
                             recordingViewModel: self.recordingViewModel)
            case.charts:
                ValuesView(viewModel: self.motionViewModel)
            case .recordingsList:
                RecordingsListView()
                    .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
            case .jumpAnalysis:
                JumpListView()
                    .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
            case .none:
                Text("Select a View")
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
