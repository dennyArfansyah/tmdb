//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reusedIdentifier = "MovieTableViewCell"
    
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
