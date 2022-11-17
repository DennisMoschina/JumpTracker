//
//  RecordingsView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 08.11.22.
//

import SwiftUI
import Charts

struct RecordingsView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.startTime)
    ]) var recordings: FetchedResults<Recording>
    
    var body: some View {
        List(self.recordings) { recording in
            RecordingRow(recording: recording)
        }
    }
}

struct RecordingRow: View {
    let recording: Recording
    
    var body: some View {
        HStack {
            Text(self.recording.name ?? "N/A")
            
            Spacer()
            
            Text(self.recording.startTime?.description ?? "N/A")
                .foregroundColor(.secondary)
        }
    }
}

struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
