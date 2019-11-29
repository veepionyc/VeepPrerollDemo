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

class VeepioViewController:
UIViewController  //, IMAAdsLoaderDelegate, IMAAdsManagerDelegate
    
{

    
    
    //MARK: - properties
    
    @IBOutlet var preview: VPKPreview!
    
    
    
    //MARK: - viewController lifecycle
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configurePreview()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    //MARK: - configuration
    
    func configurePreview()
    {
        guard let image = UIImage.init(named: "tomcruise") else {return}
        let imageURL = URL(string: "youtube://ITjsb22-EwQ")!
        let previewImage: VPKImage = VPKImage(image: image, url:imageURL)
        self.preview.image = previewImage
//        self.preview.delegate = self
    }

    
    
    
}


extension VeepioViewController: VPKPreviewDelegate {
    func vpkPreviewTouched(_ preview: VPKPreview, image: VPKImage) {
        /*
         invoking the VPKVeepViewer
         set the viewer's transitioning delegate to a custom transitioning object (or nil) to override supplied transition animations
         */
        
        
        guard let vpViewer = VPKit.viewer(with: image, from: view) else { return }
        vpViewer.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vpViewer, animated: true, completion: nil)
    }
    
  
}

extension VeepioViewController: VPKVeepViewerDelegate {
    func veepViewer(_ viewer: VPKVeepViewer, didFinishViewingWithInfo info: [AnyHashable : Any]?)
    {
        
        // the veep object can be read from info["veep"] if required
        
        self.dismiss(animated: true, completion:  {
            self.preview?.showIcon(true)
        })
    }
    
    func veepViewerDidCancel(_ viewer: VPKVeepViewer) {
        self.dismiss(animated: true, completion: nil)
    }
}
