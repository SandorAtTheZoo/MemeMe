//
//  Meme.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/16/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var textArr = ["UP", "MINE"]
    var imageOriginal : UIImage? = UIImage(named: "testImage")
    var imageMeme : UIImage? = UIImage(named: "testImage")
    
    init() {
        
    }
    
    init(textArray: [String], imageOrg : UIImage, imageMeme : UIImage) {
        textArr = textArray
        imageOriginal = imageOrg
        self.imageMeme = imageMeme
    }
    
}
