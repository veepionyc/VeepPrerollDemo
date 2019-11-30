//
//  PrerollHandler.swift
//  TestAdView
//
//  Created by jonathan on 29/11/2019.
//  Copyright © 2019 Foundry. All rights reserved.
//

import GoogleInteractiveMediaAds
import UIKit
import AVFoundation
import os

class PrerollHandler : NSObject {
    
    deinit {
        adsManager?.destroy()
        stopListening()
        self.playerLayer.removeFromSuperlayer()
    }

    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    var prerollPlayer : AVPlayer
    let playerLayer : AVPlayerLayer!
    weak var videoView: UIView!
    let completion: ()->()
  
    init(view: UIView, preroll:URL, completion:@escaping (()->())) {
        self.completion = completion
        self.videoView   = view
        self.prerollPlayer = AVPlayer(url: preroll)
        self.playerLayer = AVPlayerLayer(player: self.prerollPlayer)
        super.init()
        setUpContentPlayer()
        setUpAdsLoader()
        requestAds()
        startListening()
    }
    
    func setUpContentPlayer() {
        playerLayer.frame = videoView.layer.bounds
        videoView.layer.addSublayer(playerLayer)
    }
    
    func setUpAdsLoader() {
           adsLoader = IMAAdsLoader(settings: nil)
           adsLoader.delegate = self
       }
    

    func requestAds() {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: videoView, companionSlots: nil)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: GoogleViewController.kTestAppAdTagUrl,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: nil,
            userContext: nil)
        
        adsLoader.requestAds(with: request)
    }
    
    func startListening () {
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.contentDidFinishPlaying(_:)),
                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                  object: self.prerollPlayer.currentItem);
    }
    
    func stopListening() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if (notification.object as! AVPlayerItem) ==  self.prerollPlayer.currentItem {
            adsLoader.contentComplete()
        }
    }
}


extension PrerollHandler : IMAAdsLoaderDelegate {
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        
        // Create ads rendering settings and tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
//        adsRenderingSettings.webOpenerPresentingController = self
        
        // Initialize the ads manager.
        adsManager.initialize(with: adsRenderingSettings)
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        self.completion()
    }
    
    
}

extension PrerollHandler : IMAAdsManagerDelegate {
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        os_log("%@ not handled",#function)
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        os_log("%@ not handled",#function)
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        switch (event.type) {
        case .LOADED:
            adsManager.start()
        case .ALL_ADS_COMPLETED:
            completion()
        default:
            break
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        print("AdsManager error: \(String(describing: error.message))")
        self.completion()
    }
    
    
}

