//
//  DetailViewController.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/23/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var memeDetailImage: UIImageView!
    
    var memeDetail = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        memeDetailImage.image = memeDetail.imageMeme
    }

}
