//
//  AlertManager.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 01.02.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class AlertManager {
    
    static func showAlert(withTitle title: String, withMessage message: String, inViewController viewController: UIViewController, actionHandler: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
    
}
