//
//  VeepioViewController.swift
//  TestAdView
//
//  Created by jonathan on 28/11/2019.
//  Copyright © 2019 Foundry. All rights reserved.
//

import GoogleInteractiveMediaAds

import UIKit
import VPKit

class VeepioViewController: UIViewController  {
  
    //MARK: - properties
    
    @IBOutlet weak var prerollSwitch: UISwitch!
    @IBOutlet var preview: VPKPreview!
    var prerollHandler: PrerollHandler?
    
    //MARK: - viewController lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePreview()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        /**
         Rotation handlling. See also the App Delegate. This is an example to show how the app can be constrained to portrait but allow the veep video player to play in any orientation.
         */
        return UIInterfaceOrientationMask.portrait
    }
    
    //MARK: - configuration
    
    func configurePreview() {
        guard let image = UIImage.init(named: "tomcruise") else {return}
        let imageURL = URL(string: "youtube://ITjsb22-EwQ")!
        let previewImage: VPKImage = VPKImage(image: image, url:imageURL)
        self.preview.image = previewImage
        
        /**
         Setting the optional delegate so that we can intercept launch of the veep viewer and insert a preroll. This step is unnecessary for basic playback without prerolls.
         */
        self.preview.delegate = self
    }
    
    //MARK: - switch action
    
    @IBAction func prerollSwitched(_ sender: UISwitch) {
        //cancelling a preroll video
        if sender.isOn == false {
            self.prerollHandler = nil
        }
    }
    
  
}

//MARK: -
extension VeepioViewController: VPKPreviewDelegate {
    
    static let kTestAppAdTagUrl =
        "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
            "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
            "output=vast&unviewed_position_start=1&" +
            "cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=";
    
    
    /// - Tag: vpkPreviewTouched
    func vpkPreviewTouched(_ preview: VPKPreview, image: VPKImage) {
        /**
         Invoking the VPKVeepViewer.
         */
        
        
        if prerollSwitch.isOn == true {
            //with preroll
            self.prerollHandler = PrerollHandler.init(view: preview, preroll: URL.init(string: VeepioViewController.kTestAppAdTagUrl)!, completion: { [weak self] in
                self?.prerollHandler = nil
                guard let vpViewer = VPKit.viewer(with:preview) else { return }
               
                //It is essential to use this custom present method to obtain the correct rotation behaviour for the veep video player.
                VPKit.present(vpViewer);
            })
        } else {
            //without preroll. If the VPKPreview delegate is not set this code is not needed.
            guard let vpViewer = VPKit.viewer(with:preview) else { return }
            VPKit.present(vpViewer);
        }
    }
}




