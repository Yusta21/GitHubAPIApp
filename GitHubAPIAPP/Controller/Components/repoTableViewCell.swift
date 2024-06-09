//
//  repoTableViewCell.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import UIKit

class repoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var repoName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(name: String) {
           repoName.text = name
       }

}
