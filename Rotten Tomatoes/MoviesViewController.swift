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
    let apiURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=50&country=us"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var errorLabel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getRottenTomatoesData", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        errorLabel.frame.origin.y = 108 //Quick fix for error label positioning.
        
        getRottenTomatoesData()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 20))
        headerView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        
        var movie = movies[section]
        var title = movie["title"] as! String
        
        var usernameLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 250, height: 20))
        usernameLabel.text = title;

        
        usernameLabel.font = UIFont.boldSystemFontOfSize(15)
        usernameLabel.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        headerView.addSubview(usernameLabel)
        
        return headerView;
    }

    func getRottenTomatoesData() {
        SVProgressHUD.show()
        var url = NSURL(string: apiURL)!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            self.errorLabel.hidden = error == nil   //Indicate there was an error
            
            var moviesJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            self.movies = moviesJSON["movies"] as! [NSDictionary]
            self.filteredData = self.movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movieCell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieInfo = filteredData[indexPath.section]
        let url_str = movieInfo.valueForKeyPath("posters.thumbnail") as! String
        let url = NSURL(string: url_str)
        
        movieCell.thumbnail.setImageWithURL(url)
        movieCell.movieSynposis.text = movieInfo["synopsis"] as? String
        
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
        var movieDetailsViewController = segue.destinationViewController as! MovieDetailsTestViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        
        movieDetailsViewController.movie = movies[indexPath.section]
        
        
        
    }

}
