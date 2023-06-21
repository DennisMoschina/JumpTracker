//
//  CompactHomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//
//

import SwiftUI

struct CompactHomeView: View {
    private var motionViewModel: MotionViewModel = MotionViewModel(motionManager: MotionManager.singleton)
    private var recordingViewModel: MotionRecorderViewModel = MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder())
    
    var body: some View {
        NavigationView {
            TabView {
                ContentView(motionViewModel: self.motionViewModel,
                            recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder()))
                    .tabItem {
                        Label("Current", systemImage: "play")
                    }
                
                ValuesView(viewModel: self.motionViewModel)
                    .tabItem {
                        Label("Charts", systemImage: "chart.xyaxis.line")
                    }
                
                RecordingsListView()
                    .tabItem {
                        Label("Recordings", systemImage: "recordingtape")
                    }
            }
        }
    }
}

struct CompactHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CompactHomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
