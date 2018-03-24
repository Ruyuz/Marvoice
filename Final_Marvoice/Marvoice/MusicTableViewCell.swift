//
//  MusicTableViewCell.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/14/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var singer: UILabel!
    
}
