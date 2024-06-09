//
//  ErrorManager.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import Foundation
import UIKit


func handleError(_ error: GHError, viewController: UIViewController) {
        var message = ""
        switch error {
        case .invalidURL:
            message = "Invalid URL"
        case .invalidResponse:
            message = "Invalid response"
        case .invalidData:
            message = "Invalid data"
        case .invalidUser:
            message = "User not found"
        }
        showAlert(viewController: viewController, message: message)
    }

func showAlert(viewController: UIViewController, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
