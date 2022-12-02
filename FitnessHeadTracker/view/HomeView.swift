//
//  HomeView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            switch self.horizontalSizeClass {
            case .compact:
                CompactHomeView()
            case .regular:
                RegularHomeView()
            default:
                Text("something really weird happened")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
