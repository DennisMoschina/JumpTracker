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
        SortDescriptor(\.startTime, order: .reverse)
    ]) var recordings: FetchedResults<Recording>
    
    var body: some View {
        NavigationStack {
            Group {
                if self.recordings.isEmpty {
                    HStack(alignment: .center) {
                        Text("No Recordings")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(uiColor: .systemGroupedBackground))
                } else {
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
                }
            }
            .navigationTitle("Recordings")
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
        RecordingsListView()
            .environment(\.persistenceController, PersistenceController.preview)
    }
}
