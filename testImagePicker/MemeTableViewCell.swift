//
//  MemeTableViewCell.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/24/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

//helpful reference :
//http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeTableCellImage: UIImageView!
    @IBOutlet weak var memeTableCellUpperText: UILabel!
    @IBOutlet weak var memeTableCellLowerText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(upperText : String, lowerText : String) {
        memeTableCellUpperText.text = upperText
        memeTableCellLowerText.text = lowerText
    }

}
