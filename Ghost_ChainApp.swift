//
//  Ghost_ChainApp.swift
//  Ghost Chain
//
//  Created by Temisan Taire on 5/13/24.
//

import SwiftUI

@main
struct Ghost_ChainApp: App {
    @StateObject private var vm = HomeViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                HomeView()
//                    .navigationBarHidden(true)
//            }
//            .environmentObject(vm)
            
            NavigationView {
                ChatBotView()
                    .navigationBarHidden(true)
            }
        }
    }
}
