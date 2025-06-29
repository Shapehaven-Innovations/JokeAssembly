// NativeAdView.swift
import SwiftUI
import GoogleMobileAds

struct NativeAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        // Set up your native ad layout here using subviews
        // For simplicity, use a GADTemplateView or a custom layout

        // Example: using GADTemplateView (optional, otherwise, custom layout)
        // let templateView = GADTemplateView()
        // nativeAdView.addSubview(templateView)
        // return nativeAdView

        return nativeAdView
    }

    func updateUIView(_ uiView: GADNativeAdView, context: Context) {
        // Load and bind the ad
        let adLoader = GADAdLoader(adUnitID: adUnitID,
                                   rootViewController: UIApplication.shared.windows.first?.rootViewController,
                                   adTypes: [.native],
                                   options: nil)

        adLoader.delegate = context.coordinator
        adLoader.load(GADRequest())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GADNativeAdLoaderDelegate {
        var parent: NativeAdView

        init(_ parent: NativeAdView) {
            self.parent = parent
        }

        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            // Bind ad to GADNativeAdView
            // You'll need to bind the ad's headline, image, etc. to the uiView's subviews
            // Example:
            // if let nativeAdView = parent.uiView as? GADNativeAdView {
            //     nativeAdView.nativeAd = nativeAd
            //     // configure ad assets (headline, media, etc.)
            // }
        }
    }
}
