//
//  DetailViewController.swift
//  CatchJob
//
//  Created by 陈秀鹏 on 2017/8/2.
//  Copyright © 2017年 com.linglustudio. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var article: DataModel?
    
    @IBOutlet weak var textviewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show the navigation
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        // display the title
        self.navigationItem.title = article?.title
        
        // display the content
        textviewContent.text = article?.content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // modifty the UITextView content offset
        textviewContent.setContentOffset(CGPoint.zero, animated: false)
    }
}
