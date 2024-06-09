//
//  profileTableViewCell.swift
//  GitHubAPIAPP
//
//  Created by Noel H. Yusta on 8/6/24.
//

import UIKit

class profileTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setValues(name:String, imageUrl:String) {
        
        userName.text = name
        
        loadImage(from: imageUrl)
        }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
                return
            }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                self.userImageView.image = image
                    generalConfigureImage(image: self.userImageView)
                }
            }
        }
    }
    
}
