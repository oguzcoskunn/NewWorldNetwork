//
//  BannerAd.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final class BannerVC: UIViewControllerRepresentable  {
    let unitNumber: Int
    
    init(unitNumber: Int) {
        self.unitNumber = unitNumber
    }
    
    let unitIDs = [
        bannerAdKey1, bannerAdKey2, bannerAdKey3, bannerAdKey4
    ]

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = unitIDs[unitNumber < unitIDs.count ? unitNumber : unitNumber % unitIDs.count]
        
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
