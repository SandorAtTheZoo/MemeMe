//
//  MemeCollectionViewCell.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/23/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

//custom collection cell
class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeCollUpperText: UILabel!
    @IBOutlet weak var memeCollImage: UIImageView!
    @IBOutlet weak var memeCollLowerText: UILabel!
    
    func setText (upperText : String, lowerText : String) {
        memeCollUpperText.text = upperText
        memeCollLowerText.text = lowerText
    }
}
