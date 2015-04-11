//
//  MovieCell.swift
//  Rotten Tomatoes
//
//  Created by Nathaniel Okun on 4/9/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSynposis: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
