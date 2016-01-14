//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Eric Suarez on 1/5/16.
//  Copyright © 2016 Eric Suarez. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var filteredData: [String]!
    
    override func viewDidAppear(animated: Bool) {
        EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 1)

//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
//        let request = NSURLRequest(URL: url!)
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate:nil,
//            delegateQueue:NSOperationQueue.mainQueue()
//        )
//        
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
//            completionHandler: { (dataOrNil, response, error) in
//                if let data = dataOrNil {
//                    
//                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
//                        data, options:[]) as? NSDictionary {
//                            NSLog("response: \(responseDictionary)")
//                            
//                            self.movies = responseDictionary["results"] as! [NSDictionary]
//                            self.tableView.reloadData()
//                            EZLoadingActivity.hide(success: true, animated: true)
//                            
//                    }
//                    
//                } else {
//                    EZLoadingActivity.hide(success: false, animated: true)
//                }
//        });
//        task.resume()
        
        self.callMovies()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.setImageWithURL(imageUrl!)
        
        return cell
    }
    
    func callMovies() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            EZLoadingActivity.hide(success: true, animated: true)
                            
                    }
                    
                } else {
                    EZLoadingActivity.hide(success: false, animated: true)
                }
        });
        task.resume()

    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.callMovies()
            self.refreshControl.endRefreshing()
        })
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
