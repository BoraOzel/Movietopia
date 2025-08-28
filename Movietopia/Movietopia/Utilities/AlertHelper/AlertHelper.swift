//
//  AlertHelper.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import UIKit

class AlertHelper {
    static func showAlert(on vc: UIViewController,
                          title: String,
                          message: String,
                          buttonTitle: String = "Tamam") {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let retryButton = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(retryButton)
    
        vc.present(alert, animated: true, completion: nil)
    }
}
