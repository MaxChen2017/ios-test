//
//  ViewController.swift
//  CatchJob
//
//  Created by 陈秀鹏 on 2017/8/2.
//  Copyright © 2017年 com.linglustudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // UITableView
    @IBOutlet weak var tableviewData: UITableView!
    
    // UIRefreshControl
    var refreshControl: UIRefreshControl!
    
    // custom loading UIView
    var loadingView: UIView!
    
    // custom loading UIImageView
    var loadingImageView: UIImageView!
    
    // data
    var arrayData = [DataModel]()
    
    // current index of the data
    var currentIndex = -1
    
    // whether the loadingImageView is animating
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init the view status
        self.initView()
        
        // init the variables
        currentIndex = -1
        isAnimating = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide the navigation and choose the style of status bar
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    func initView() {
        // init UIRefreshControl
        refreshControl = UIRefreshControl()
        
        // hide its own loading view
        refreshControl.tintColor = UIColor.clear
        
        // target
        refreshControl.addTarget(self, action: #selector(self.requestData), for: .valueChanged)
        
        // custom the loading view
        loadingImageView = UIImageView(image: UIImage(named: "Oval"))
        loadingView = UIView(frame: refreshControl.bounds)
        loadingView.backgroundColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        loadingView.clipsToBounds = true
        loadingView.addSubview(loadingImageView)
        
        // add the loading view
        refreshControl.addSubview(loadingView)
        
        // add the RefreshControl
        tableviewData.addSubview(refreshControl)
        
        // modify the tableview's content inset
        tableviewData.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        
        // display the data
        let article = arrayData[indexPath.row] as DataModel
        
        // title
        cell.labelTitle.text = article.title
        
        // subtitle
        cell.labelSubtitle.text = article.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select one row
        currentIndex = indexPath.row
        
        // animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // goto detail page
        self.performSegue(withIdentifier: "segueToDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailVC" {
            // get the VC object
            let nextVC = segue.destination as! DetailViewController
            
            // pass the variable
            nextVC.article = arrayData[currentIndex]
        }
    }
    
    // UITableView did scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // UIRefreshControl bounds
        var refreshBounds = refreshControl.bounds
        
        // calculate the current position of loading image
        let pullDistance = max(0.0, -refreshControl.frame.origin.y)
        let loadingImageWidth = loadingImageView.bounds.size.width
        let loadingImageHeight = loadingImageView.bounds.size.height
        let midX = tableviewData.frame.size.width / 2.0
        let loadingImageX = midX - loadingImageWidth / 2.0
        let loadingImageY = pullDistance / 2.0 - loadingImageHeight / 2.0
        var loadingImageFrame = loadingImageView.frame
        loadingImageFrame.origin.x = loadingImageX
        loadingImageFrame.origin.y = loadingImageY
        loadingImageView.frame = loadingImageFrame
        
        // calculate the current position of loading view
        refreshBounds.size.height = pullDistance
        loadingView.frame = refreshBounds
        
        if !self.isAnimating {
            // rotate the loading image
            animateLoadingView()
        }
    }
    
    func animateLoadingView() {
        // begin rotating
        self.isAnimating = true
        
        // UIAnimate
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            // rotate
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            if self.refreshControl.isRefreshing {
                
                // continue to rotate
                self.animateLoadingView()
            } else {
                // stop rotate
                self.isAnimating = false
            }
        }
    }
    
    // request data via network
    func requestData() {
        NetworkManager.sharedInstance.getRequest(urlString: "data.json", params: nil, success: { response in
            
            // parse response data
            self.parseResponseData(response: response)
            
            // reload UITableView
            self.tableviewData.reloadData()
            
            // stop UIRefreshControl
            self.refreshControl.endRefreshing()
        }) { error in
            
            // stop UIRefreshControl
            self.refreshControl.endRefreshing()
        }
    }
    
    // parse response
    func parseResponseData(response: [NSDictionary]) {
        
        // clear the array
        self.arrayData.removeAll()
        
        // translate the response into DataModel struct
        for article in response {
            let newData = DataModel(id: article.object(forKey: "id") as! Int, title: article.object(forKey: "title") as! String, subtitle: article.object(forKey: "subtitle") as! String, content: article.object(forKey: "content") as! String)
            
            // append
            self.arrayData.append(newData)
        }
    }
}

