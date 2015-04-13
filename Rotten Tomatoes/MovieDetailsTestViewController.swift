//
//  MovieDetailsTestViewController.swift
//  Rotten Tomatoes
//
//  Created by Nathaniel Okun on 4/13/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class MovieDetailsTestViewController: UIViewController {
    var movie: NSDictionary!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePhoto: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie["title"] as? String
        movieSynopsis.text = movie["synopsis"] as? String
        var year = movie["year"] as? Int
        movieYear.text = String(year!)
        movieRating.text = movie["mpaa_rating"] as? String
        movieTitle.adjustsFontSizeToFitWidth = true
        movieSynopsis.adjustsFontSizeToFitWidth = true
        
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
