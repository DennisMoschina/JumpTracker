//
//  JumpListView.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 11.07.23.
//

import SwiftUI

struct JumpListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.startTime, order: .reverse)
    ]) var recordings: FetchedResults<Recording>
    
    @State private var path: [Recording] = []
    
    var body: some View {
        NavigationStack(path: self.$path) {
            List(self.recordings) { recording in
                NavigationLink(value: recording) {
                    HStack {
                        Text(recording.name ?? "N/A")
                        Spacer()
                        Text(recording.startTime?.description ?? "N/A")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationDestination(for: Recording.self) { recording in
                JumpAnalysisView(jumpCalculatorViewModel: JumpCalculatorViewModel(recording: recording, trained: true))
            }
            .navigationTitle("Jump Recordings")
        }
    }
}

struct JumpListView_Previews: PreviewProvider {
    static var previews: some View {
        JumpListView()
    }
}
