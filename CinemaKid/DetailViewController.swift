//
//  DetailViewController.swift
//  CinemaKid
//
//  Created by Lingostar on 2015. 10. 12..
//  Copyright © 2015년 CodersHigh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    let imageQueue:NSOperationQueue = NSOperationQueue()
    
    var detailItem: [String:String]? {
        willSet {
            
        }
        didSet {
            // Update the view.
            if let _ = self.view {
                self.configureView()
            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let movieDetail = self.detailItem {
            titleLabel.text = movieDetail["title"]
            detailDescriptionLabel.text = movieDetail["description"]
            let imageUpdateOperation = NSBlockOperation(block: {
                let posterCode = movieDetail["posterCode"]
                let posterURL = NSURL(string: "http://125.209.197.227/cinemakid/stillcut/load/" + posterCode!)
                let posterData = NSData(contentsOfURL: posterURL!)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.posterImageView.image = UIImage(data: posterData!)
                })
            
            })
            imageQueue.addOperation(imageUpdateOperation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

