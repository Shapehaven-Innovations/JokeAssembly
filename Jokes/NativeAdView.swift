//
//  NativeAdView.swift
//  Jokes
//
//  Created by user on 6/28/25.
//
import SwiftUI
import GoogleMobileAds

struct NativeInlineAdView: UIViewRepresentable {
    let adUnitID: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GoogleMobileAds.NativeAdView {
        let adView = GoogleMobileAds.NativeAdView()
        adView.backgroundColor = UIColor.clear

        // Headline
        let headlineLabel = UILabel()
        headlineLabel.numberOfLines = 2
        headlineLabel.font = .systemFont(ofSize: 17, weight: .bold)
        headlineLabel.textColor = .white
        adView.headlineView = headlineLabel
        adView.addSubview(headlineLabel)

        // Call to Action
        let ctaButton = UIButton(type: .system)
        ctaButton.setTitleColor(.systemBlue, for: .normal)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        adView.callToActionView = ctaButton
        adView.addSubview(ctaButton)

        // Icon
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 4
        iconView.clipsToBounds = true
        adView.iconView = iconView
        adView.addSubview(iconView)

        // Ad Attribution Label
        let adAttribution = UILabel()
        adAttribution.text = "Ad"
        adAttribution.textColor = .systemYellow
        adAttribution.font = .systemFont(ofSize: 12, weight: .bold)
        adAttribution.layer.borderColor = UIColor.systemYellow.cgColor
        adAttribution.layer.borderWidth = 1
        adAttribution.layer.cornerRadius = 4
        adAttribution.clipsToBounds = true
        adAttribution.textAlignment = .center
        adView.addSubview(adAttribution)

        // Layout
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        adAttribution.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            adAttribution.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
            adAttribution.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
            adAttribution.widthAnchor.constraint(equalToConstant: 28),
            adAttribution.heightAnchor.constraint(equalToConstant: 18),

            iconView.leadingAnchor.constraint(equalTo: adAttribution.trailingAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),

            ctaButton.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
            ctaButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            ctaButton.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 10),
            ctaButton.heightAnchor.constraint(equalToConstant: 36),
            ctaButton.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -8)
        ])

        // Load the ad
        let loader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first?.rootViewController }
                .first,
            adTypes: [.native],
            options: []
        )
        loader.delegate = context.coordinator
        context.coordinator.nativeAdView = adView
        loader.load(Request())

        return adView
    }

    func updateUIView(_ uiView: GoogleMobileAds.NativeAdView, context: Context) {}

    class Coordinator: NSObject, NativeAdLoaderDelegate {
        var parent: NativeInlineAdView
        weak var nativeAdView: GoogleMobileAds.NativeAdView?

        init(_ parent: NativeInlineAdView) {
            self.parent = parent
        }

        // Ad loaded successfully
        func adLoader(_ adLoader: AdLoader, didReceive nativeAd: GoogleMobileAds.NativeAd) {
            guard let adView = nativeAdView else { return }
            (adView.headlineView as? UILabel)?.text = nativeAd.headline
            (adView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
            adView.iconView?.isHidden = nativeAd.icon == nil
            if let icon = nativeAd.icon {
                (adView.iconView as? UIImageView)?.image = icon.image
            }
            adView.nativeAd = nativeAd
        }

        // Ad failed to load (Required for protocol conformance)
        func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
            print("❌ Failed to load native ad: \(error)")
        }
    }
}
