//
//  MasterViewController.swift
//  CinemaKid
//
//  Created by Lingostar on 2015. 10. 12..
//  Copyright © 2015년 CodersHigh. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    //var objects = [AnyObject]()
    let dataCenter:CinemaCenter = CinemaCenter()
    let thumbnailQueue:NSOperationQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        dataCenter.requestToServer({
            self.tableView.reloadData()
        })
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = dataCenter.result[indexPath.row] as? [String:String]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCenter.result.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if let movieInfo = dataCenter.result[indexPath.row] as? [String:String] {
            cell.textLabel?.text = movieInfo["title"]
            cell.detailTextLabel?.text = movieInfo["genre"]
            cell.imageView?.image = UIImage(named: "loading")
            print("\(movieInfo)")
            
            
            
            let thumbnailUpdateOperation = NSBlockOperation(block: {
            
                let posterCode = movieInfo["posterCode"]
                let posterURL = NSURL(string: "http://125.209.197.227/cinemakid/stillcut/load/" + posterCode!)
                let posterData = NSData(contentsOfURL: posterURL!)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    cell.imageView?.image = UIImage(data: posterData!)
                })
            })
            thumbnailQueue.addOperation(thumbnailUpdateOperation)
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}

