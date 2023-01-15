//
//  RecordingsView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 08.11.22.
//

import SwiftUI
import Charts

struct RecordingsListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.startTime)
    ]) var recordings: FetchedResults<Recording>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.recordings) { recording in
                    RecordingRow(recording: recording)
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        let recording = self.recordings[i]
                        self.managedObjectContext.delete(recording)
                    }
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

struct RecordingRow: View {
    let recording: Recording
    
    var body: some View {
        NavigationLink(destination: RecordingDetailView(viewModel: RecordingViewModel(recording: recording))) {
            HStack {
                Text(self.recording.name ?? "N/A")
                
                Spacer()
                
                Text(self.recording.startTime?.description ?? "N/A")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct RecordingsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecordingsListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
