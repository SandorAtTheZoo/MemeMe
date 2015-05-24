//
//  SentMemesCollectionViewController.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/18/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes : [Meme]!
    @IBOutlet weak var collView: UICollectionView!

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
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        collectionView?.reloadData()
        
    }
    //this fixes a glitch where collection view doesn't display content correctly first time
    //(too high in nav bar)...upon navigating away and returning, it worked, but this resolves that
    //http://stackoverflow.com/questions/18896210/ios7-uicollectionview-appearing-under-uinavigationbar
    override func viewDidLayoutSubviews() {
        let top = self.topLayoutGuide.length
        let bottom = self.bottomLayoutGuide.length
        let newInsets = UIEdgeInsetsMake(top, 0, bottom, 0)
        self.collView.contentInset = newInsets
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.memeCollImage.image = meme.imageMeme
        cell.setText(meme.textArr[0], lowerText: meme.textArr[1])
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        let meme = memes[indexPath.item]
        newViewController.memeDetail = meme
        
        self.navigationController!.pushViewController(newViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
