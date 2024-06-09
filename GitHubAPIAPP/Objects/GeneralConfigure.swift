//
//  GeneralConfigure.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import Foundation
import UIKit


func generalConfigureImage(image: UIImageView){
    
    image.layer.cornerRadius = image.frame.height/2
    image.layer.shadowOffset = CGSize(width: 0, height: 0)
    image.layer.shadowOpacity = 0.6
    image.layer.shadowRadius = 4.0
    image.layer.borderWidth = 2
    image.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    image.layer.masksToBounds = true
    
    
}


func generalConfigureTableView(table: UITableView) {
    
    
    table.layer.cornerRadius = 6
    table.layer.shadowOffset = CGSize(width: 0, height: 0)
    table.layer.shadowOpacity = 0.6
    table.layer.shadowRadius = 4.0
    table.layer.borderWidth = 2
    table.layer.borderColor = UIColor(named: "borderColor")?.cgColor
   
    
    
    
}

func generalConfigureButton(button: UIButton) {
    
    button.tintColor = UIColor(named: "borderColor")
    button.layer.cornerRadius = 6
    button.layer.shadowOffset = CGSize(width: 0, height: 0)
    button.layer.shadowOpacity = 0.6
    button.layer.shadowRadius = 4.0
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(named: "borderColor")?.cgColor
}

