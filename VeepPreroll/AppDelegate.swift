//
//  AppDelegate.swift
//  TestAdView
//
//  Created by jonathan on 27/11/2019.
//  Copyright © 2019 Foundry. All rights reserved.
//

import UIKit
import VPKit
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
         
         APP CREDENTIALS: required
         
         These app credentials are for testing purposes only.
         To obtain credentials unique to your app visit the VEEPIO developer portal
         https://developer.veep.io
         */
        
        
        let appId = "VEEPIO_by_url_test_app_id"
        let clientId = "1zArpBErovQ1MjVHvigJqXwE8qt47U2Yy5XzG3CP"
        let clientSecret = "VpLIvEetceUnHBEIf6fLUwLxELBh2QesZ6iLLiPHCesRLXfOLLJNcFfmp03wJfGaJquO3V8KqHjtvzlufuXfWWgcpWVw9wxfBJNYdZh96JHV5hk44dJbqiCqplrKcSml"
        
        /*
         
         INITIALISATION
         
         */
        
        VPKit.setApplicationId(appId,
                               clientId: clientId,
                               clientSecret: clientSecret)



 
 
        return true
    }

  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      /*
       if the host app is restricting orientation in the app delegate,
       rotation should be enabled for the Veep Viewer like this:
       */
      
      var mask : UIInterfaceOrientationMask = .portrait  // app default
      
      if UIApplication.shared.keyWindow is VPKWindow {
          mask = .allButUpsideDown  // veep viewer default
      }
      
      return mask;
  }


}

