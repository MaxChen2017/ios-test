//
//  CatchJobTests.swift
//  CatchJobTests
//
//  Created by 陈秀鹏 on 2017/8/2.
//  Copyright © 2017年 com.linglustudio. All rights reserved.
//

import XCTest
@testable import CatchJob

class CatchJobTests: XCTestCase {
    var mainVC: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        mainVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseData() {
        let id = 1
        let title = "abc"
        let subtitle = "hello world"
        let content = "test test"
        let oneArticle: NSDictionary = ["id": id, "title": title, "subtitle": subtitle, "content": content]
        
        var response: [NSDictionary] = [oneArticle]
        mainVC.parseResponseData(response: response)
        XCTAssertEqual(mainVC.arrayData.count, 1, "one item parse error!")
        let article = mainVC.arrayData[0]
        XCTAssertEqual(article.id, id, "parse id error!")
        XCTAssertEqual(article.title, title, "parse title error!")
        XCTAssertEqual(article.subtitle, subtitle, "parse subtitle error!")
        XCTAssertEqual(article.content, content, "parse content error!")
        
        response.append(oneArticle)
        mainVC.parseResponseData(response: response)
        XCTAssertEqual(mainVC.arrayData.count, 2, "two item parse error!")
    }
    
}
