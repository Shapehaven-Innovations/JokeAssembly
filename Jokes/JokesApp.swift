//
//  JokesApp.swift
//  Jokes
//
//  Created by user on 5/15/24.
//

import SwiftUI

@main
struct JokesApp: App {
    // Register AppDelegate for SDK initialization
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
