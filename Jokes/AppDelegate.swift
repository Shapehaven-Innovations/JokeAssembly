// AppDelegate.swift
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // 1) Initialize the Mobile Ads SDK
        MobileAds.shared.start { status in
            status.adapterStatusesByClassName.forEach { name, adapter in
                print("GMA Adapter \(name): \(adapter.state) — \(adapter.description)")
            }
        }

        #if DEBUG
        // 2) In DEBUG, register test device IDs.
        //    Simulator will automatically return test ads—you don’t need to specify its ID.
        //    If you want to test on a real iPhone, run once, copy the printed
        //    device hash from your console, and paste it here as a string:
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [
            // "<YOUR-DEVICE-ID-HERE>"
        ]
        #endif

        return true
    }
}

