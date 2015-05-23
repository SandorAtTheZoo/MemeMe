//
//  SentMemesTableViewController.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/18/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

//having problems with navigation controllers inside of navigation controllers
//https://github.com/John-Lluch/SWRevealViewController/issues/98
//just don't do it

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        //TODO:REMOVE DEBUG CODE
        //memes.insert(Meme(), atIndex: 0)
        
        //much heartache to recognize that this needed to be done
        tblView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numMemes = self.memes?.count {
            return numMemes
        } else {
            return 0
        }

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        //set cell to meme data
        cell.imageView?.image = meme.imageMeme
        cell.textLabel?.text = meme.textArr[0]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
