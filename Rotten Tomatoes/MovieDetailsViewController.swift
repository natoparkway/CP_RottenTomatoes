//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Nathaniel Okun on 4/9/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: NSDictionary!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var moviePhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        var year = movie["year"] as? Int
        yearLabel.text = String(year!)
        ratingLabel.text = movie["mpaa_rating"] as? String
        titleLabel.adjustsFontSizeToFitWidth = true
        synopsisLabel.adjustsFontSizeToFitWidth = true
        
        addPhoto()


        // Do any additional setup after loading the view.
    }
    
    func addPhoto() {
        var url_str = movie.valueForKeyPath("posters.detailed") as! String
        
        var range = url_str.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url_str = url_str.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        moviePhoto.setImageWithURL(NSURL(string: url_str))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
