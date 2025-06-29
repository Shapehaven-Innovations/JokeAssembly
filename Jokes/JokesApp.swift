// JokesApp.swift
import SwiftUI

@main
struct JokesApp: App {
    // Wire up our AppDelegate so the SDK initializes at launch
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
