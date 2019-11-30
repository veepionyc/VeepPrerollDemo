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
        return UIInterfaceOrientationMask.portrait
    }
    
    //MARK: - configuration
    
    func configurePreview() {
        guard let image = UIImage.init(named: "tomcruise") else {return}
        let imageURL = URL(string: "youtube://ITjsb22-EwQ")!
        let previewImage: VPKImage = VPKImage(image: image, url:imageURL)
        self.preview.image = previewImage
        
        /**
         Setting the optional delegate so that we can intercept launch of the veep viewer and insert a preroll
         */
        self.preview.delegate = self
    }
}


extension VeepioViewController: VPKPreviewDelegate {
    
    static let kTestAppAdTagUrl =
        "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
            "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
            "output=vast&unviewed_position_start=1&" +
            "cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=";
    
    
    /// - Tag: vpkPreviewTouched
    func vpkPreviewTouched(_ preview: VPKPreview, image: VPKImage) {
        /**
         invoking the VPKVeepViewer
         set the viewer's transitioning delegate to a custom transitioning object (or nil) to override supplied transition animations
         */
        
       
        if prerollSwitch.isOn == true {
        self.prerollHandler = PrerollHandler.init(view: preview, preroll: URL.init(string: VeepioViewController.kTestAppAdTagUrl)!, completion: { [weak self] in
            self?.prerollHandler = nil

            guard let vpViewer = VPKit.viewer(with:preview) else { return }
            VPKit.present(vpViewer);
        })
        } else {
            guard let vpViewer = VPKit.viewer(with:preview) else { return }
            VPKit.present(vpViewer);
        }
    }
}




