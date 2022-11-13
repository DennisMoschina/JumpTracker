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
            Text("\(recording.startTime?.description ?? "N/A")")
        }
    }
}

struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
