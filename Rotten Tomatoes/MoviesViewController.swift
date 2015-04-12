//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Nathaniel Okun on 4/8/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var movies: [NSDictionary]! = []
    var filteredData: [NSDictionary]! = []  //Used for search
    let apiURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=10&country=us"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getRottenTomatoesData", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        getRottenTomatoesData()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func getRottenTomatoesData() {
        SVProgressHUD.show()
        var url = NSURL(string: apiURL)!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            //self.errorLabel.hidden = error == nil   //Indicate there was an error
            
            var moviesJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            self.movies = moviesJSON["movies"] as! [NSDictionary]
            self.filteredData = self.movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movieCell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieInfo = filteredData[indexPath.row]
        let url_str = movieInfo.valueForKeyPath("posters.thumbnail") as! String
        let url = NSURL(string: url_str)
        
        movieCell.thumbnail.setImageWithURL(url)
        movieCell.movieSynposis.text = movieInfo["synopsis"] as? String
        movieCell.movieTitle.text = movieInfo["title"] as? String
        
        return movieCell
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            filteredData = movies
            tableView.reloadData();
            return
        }
        
        filteredData = movies.filter({(movie: NSDictionary) -> Bool in
            var title = movie["title"] as? String
            return title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })

        
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("hey")
        var movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        
        movieDetailsViewController.movie = movies[indexPath.row]
        
        
        
    }

}
