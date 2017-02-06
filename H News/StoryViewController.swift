//
//  StoryViewController.swift
//  H News
//
//  Created by Christopher Hannah on 06/02/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import UIKit
import WebKit

class StoryViewController: UIViewController, UIWebViewDelegate {
    
    var story: HackerNews.Story?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        while (story == nil) {
            // Wait
        }
        if story != nil {
            titleLabel.text = story!.title
            scoreLabel.text = "\(story!.score)"
            authorLabel.text = story!.by
            let request = URLRequest(url: URL(string: (story?.url)!)!)
            webView.loadRequest(request)
            
            titleLabel.sizeToFit()
            
            scoreLabel.sizeToFit()
            
            let frame = scoreLabel.frame
            let rect = CGRect(x: (frame.origin.x), y: (frame.origin.y), width: (frame.width)*4, height: (frame.height))
            
            scoreLabel.frame = rect
            
            scoreLabel.layer.cornerRadius = (scoreLabel.frame.height)/4
            scoreLabel.layer.masksToBounds = true
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
