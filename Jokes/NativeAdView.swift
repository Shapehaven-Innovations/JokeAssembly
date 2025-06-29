// NativeInlineAdView.swift
import SwiftUI
import GoogleMobileAds

/// A SwiftUI wrapper around a Native Ad view with MediaView for main asset.
struct NativeInlineAdView: UIViewRepresentable {
  /// Your AdMob unit ID (use your real one in production).
  let adUnitID: String

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  func makeUIView(context: Context) -> NativeAdView {
    let adView = NativeAdView(frame: .zero)
    adView.backgroundColor = .clear

    // ── 1) “Ad” Badge ──
    let badge = UILabel()
    badge.text = "Ad"
    badge.font = .systemFont(ofSize: 12, weight: .bold)
    badge.textColor = .systemYellow
    badge.textAlignment = .center
    badge.layer.borderColor = UIColor.systemYellow.cgColor
    badge.layer.borderWidth = 1
    badge.layer.cornerRadius = 4
    badge.clipsToBounds = true
    adView.addSubview(badge)

    // ── 2) Icon (small icon) ──
    let iconView = UIImageView()
    iconView.contentMode = .scaleAspectFit
    iconView.layer.cornerRadius = 4
    iconView.clipsToBounds = true
    adView.iconView = iconView
    adView.addSubview(iconView)

    // ── 3) Headline ──
    let headline = UILabel()
    headline.numberOfLines = 2
    headline.font = .boldSystemFont(ofSize: 16)
    headline.textColor = .white
    adView.headlineView = headline
    adView.addSubview(headline)

    // ── 4) MediaView (main image/video) ──
    let mediaView = MediaView()
    adView.mediaView = mediaView
    mediaView.clipsToBounds = true
    adView.addSubview(mediaView)

    // ── 5) Call-to-Action Button ──
    let cta = UIButton(type: .system)
    cta.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    adView.callToActionView = cta
    adView.addSubview(cta)

    // ── AutoLayout ──
    [badge, iconView, headline, mediaView, cta].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate([
      // badge
      badge.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      badge.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
      badge.widthAnchor.constraint(equalToConstant: 30),
      badge.heightAnchor.constraint(equalToConstant: 18),

      // icon
      iconView.leadingAnchor.constraint(equalTo: badge.trailingAnchor, constant: 8),
      iconView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
      iconView.widthAnchor.constraint(equalToConstant: 32),
      iconView.heightAnchor.constraint(equalToConstant: 32),

      // headline
      headline.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
      headline.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      headline.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),

      // mediaView (main asset)
      mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      mediaView.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 8),
      mediaView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),

      // cta
      cta.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      cta.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      cta.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 8),
      cta.heightAnchor.constraint(equalToConstant: 36),
      cta.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -8),
    ])

    // ── Kick off the load ──
    context.coordinator.adView = adView
    context.coordinator.loadAd(unitID: adUnitID)

    return adView
  }

  func updateUIView(_ uiView: NativeAdView, context: Context) {
    // no-op
  }

  // MARK: – Coordinator

  class Coordinator: NSObject, NativeAdLoaderDelegate {
    let parent: NativeInlineAdView
    weak var adView: NativeAdView?
    private var adLoader: AdLoader?

    init(_ parent: NativeInlineAdView) {
      self.parent = parent
    }

    func loadAd(unitID: String) {
      guard
        let rootVC = UIApplication.shared.connectedScenes
          .compactMap({ $0 as? UIWindowScene })
          .flatMap({ $0.windows })
          .first(where: \.isKeyWindow)?
          .rootViewController
      else { return }

      let loader = AdLoader(
        adUnitID: unitID,
        rootViewController: rootVC,
        adTypes: [.native],
        options: nil
      )
      loader.delegate = self
      adLoader = loader            // retain it
      loader.load(Request())       // test ads on Simulator, real ads in Prod
    }

    // Fired when the ad is ready
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
      guard let adView = adView else { return }

      // 1) Headline & CTA
      (adView.headlineView as? UILabel)? .text = nativeAd.headline
      (adView.callToActionView as? UIButton)? .setTitle(nativeAd.callToAction, for: .normal)

      // 2) Icon
      if let icon = nativeAd.icon?.image {
        (adView.iconView as? UIImageView)? .image = icon
        adView.iconView?.isHidden = false
      } else {
        adView.iconView?.isHidden = true
      }

      // 3) Main media (image or video)
      adView.mediaView?.mediaContent = nativeAd.mediaContent

      // 4) Attach for tracking / click handling
      adView.nativeAd = nativeAd
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
      print("❌ Native ad failed to load:", error.localizedDescription)
    }
  }
}

