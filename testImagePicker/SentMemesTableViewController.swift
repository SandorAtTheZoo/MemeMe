//
//  SentMemesTableViewController.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/18/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

//I was having problems with navigation controllers inside of navigation controllers
//https://github.com/John-Lluch/SWRevealViewController/issues/98
//apparently just don't do it

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //memes tied to appDelegate
    var memes : [Meme]!
    @IBOutlet weak var tblView: UITableView!
    
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
        
        //get current memes value stored in appDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        
        //dynamically adjust cell row height
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 100
        
        //much heartache to recognize that this needed to be done
        //fixes the problem where no delegate methods were firing (numberOfRowsInSection...goes from there) because
        //it did not recognize that new memes were added to array, so no new rows were populated
        tblView.reloadData()
    }
    
    //seems to fix problem where first table item ends up above viewable area...could see it if 
    //you scrolled up
    override func viewDidLayoutSubviews() {
        let top = self.topLayoutGuide.length
        let bottom = self.bottomLayoutGuide.length
        let newInsets = UIEdgeInsetsMake(top, 0, bottom, 0)
        self.tblView.contentInset = newInsets
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numMemes = self.memes?.count {
            return numMemes
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //reference custom table cell class
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        //set cell to meme data
        cell.memeTableCellImage.image = meme.imageMeme
        cell.setText(meme.textArr[0], lowerText: meme.textArr[1])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //segue programmatically
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.memeDetail = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
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
