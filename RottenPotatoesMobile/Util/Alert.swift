//
//  Alert.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-12-08.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import Foundation
import UIKit

func genericAlert(alertTitle:String, alertMessage:String, vc: UIViewController) {
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    vc.present(alertController, animated: true, completion: nil)
}

func handleNetworkConnection(viewController: UIViewController) {
    if Reachability.isConnectedToNetwork() {
        // connected
    } else {
        genericAlert(alertTitle: "No Internet Connection!",
                     alertMessage: "App may not function properly.",
                     vc: viewController)
    }
}
