//
//  ReviewTableViewCell.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    static let reusedIdentifier = "ReviewTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reusedIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
