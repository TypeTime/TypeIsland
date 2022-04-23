//
//  ItemCell.swift
//  TypeRacerTypeBeat
//
//  Created by Justin Dang on 4/17/22.
//

import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBAction func itemBuy(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
