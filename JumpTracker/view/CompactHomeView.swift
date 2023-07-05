//
//  CompactHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//
//

import SwiftUI

struct CompactHomeView: View {
    var motionViewModel: MotionViewModel
    var recordingViewModel: MotionRecorderViewModel
    
    @Environment(\.persistenceController) var persistenceController
    
    var body: some View {
        TabView {
            ContentView(motionViewModel: self.motionViewModel,
                        recordingViewModel: self.recordingViewModel)
                .tabItem {
                    Label("Current", systemImage: "play")
                }
            
            NavigationView {
                ValuesView(viewModel: self.motionViewModel)
            }
            .tabItem {
                Label("Charts", systemImage: "chart.xyaxis.line")
            }
            
            NavigationView {
                RecordingsListView()
                    .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
            }
            .tabItem {
                Label("Recordings", systemImage: "recordingtape")
            }
        }
    }
}

struct CompactHomeView_Previews: PreviewProvider {
    static let motionManager: any MotionManagerProtocol = MotionManagerMock()
    static let dataRecorder: DataRecorder = DataRecorder(persistenceController: PersistenceController.preview)
    
    static var previews: some View {
        CompactHomeView(motionViewModel: MotionViewModel(motionManager: motionManager), recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder(dataRecorder: dataRecorder), hipPositionRecorder: HipPositionRecorder(dataRecorder: dataRecorder), dataRecorder: dataRecorder))
            .environment(\.persistenceController, PersistenceController.preview)
    }
}
