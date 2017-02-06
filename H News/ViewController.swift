//
//  ViewController.swift
//  H News
//
//  Created by Christopher Hannah on 04/02/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let hackerNews = HackerNews()
    
    var new: [Int] = []
    var newStories: [String : HackerNews.Story] = [:]
    
    var top: [Int] = []
    var topStories: [String : HackerNews.Story] = [:]
    
    var selectedType: HackerNews.ListType = .New
    
    let MAX_CACHE_COUNT = 100
    
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var listTypeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTableView.delegate = self
        storyTableView.dataSource = self
        
        changeListType()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPaths = storyTableView.indexPathsForSelectedRows {
            for index in indexPaths {
                storyTableView.deselectRow(at: index, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectNewSegment(_ sender: UISegmentedControl) {
        changeListType()
    }
    
    func changeListType() {
        if let currentType = listTypeControl.titleForSegment(at: listTypeControl.selectedSegmentIndex) {
            switch (currentType) {
            case "New":
                selectedType = .New
                Swift.print("Switch type to New")
                break
            case "Top":
                selectedType = .Top
                Swift.print("Switch type to Top")
                break
            default:
                selectedType = .New
                break
            }
        }
        reloadTable()
    }
    
    func reloadTable() {
        Swift.print("Reload Table Started")
        new = hackerNews.getNewList()
        top = hackerNews.getTopList()
        
        switch (selectedType) {
        case .New:
            DispatchQueue.global().async {
                for id in self.new {
                    if (!self.newStories.keys.contains("\(id)")) {
                        let story = self.hackerNews.getStory(id: id)
                        self.newStories.updateValue(story, forKey: "\(id)")
                        if (self.newStories.count > self.MAX_CACHE_COUNT) {
                            if let key = self.newStories.keys.first {
                                //self.newStories.removeValue(forKey: key)
                            }
                        }
                    }
                }
                
            }
            break
        case .Top:
            DispatchQueue.global().async {
                for id in self.top {
                    if (!self.topStories.keys.contains("\(id)")) {
                        let story = self.hackerNews.getStory(id: id)
                        self.topStories.updateValue(story, forKey: "\(id)")
                        if (self.topStories.count > self.MAX_CACHE_COUNT) {
                            if let key = self.topStories.keys.first {
                                //self.topStories.removeValue(forKey: key)
                            }
                        }
                    }
                }
                
            }
            break
        default:
            break
        }
        
        
        storyTableView.reloadData()
        Swift.print("Reload Table Finished")
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        reloadTable()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        switch (selectedType) {
        case .New:
            count = new.count
            break
        case .Top:
            count = top.count
            break
        default:
            break
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        var story: HackerNews.Story = HackerNews.Story(by: "", descendants: 0, id: 0, kids: [], score: 0, time: 0, title: "", url: "")
        
        var id = 0
        let row = indexPath.row
        
        switch (selectedType) {
        case .New:
            id = new[row]
            if (newStories.keys.contains("\(id)")) {
                story = newStories["\(id)"]!
            } else {
                story = hackerNews.getStory(id: new[indexPath.row])
                newStories.updateValue(story, forKey: "\(id)")
            }
            break
        case .Top:
            id = top[row]
            if (topStories.keys.contains("\(id)")) {
                story = topStories["\(id)"]!
            } else {
                story = hackerNews.getStory(id: top[indexPath.row])
                topStories.updateValue(story, forKey: "\(id)")
            }
            break
        default:
            break
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StoryViewController") as! StoryViewController
        controller.story = story
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryCell"
        let cell = storyTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? StoryCell
        
        var story: HackerNews.Story = HackerNews.Story(by: "", descendants: 0, id: 0, kids: [], score: 0, time: 0, title: "", url: "")
        
        var id = 0
        let row = indexPath.row
        if row == 0 {
            cell?.frame.size.height *= 2
        }
        
        switch (selectedType) {
        case .New:
            id = new[row]
            if (newStories.keys.contains("\(id)")) {
                story = newStories["\(id)"]!
            } else {
                story = hackerNews.getStory(id: new[indexPath.row])
                newStories.updateValue(story, forKey: "\(id)")
            }
            break
        case .Top:
            id = top[row]
            if (topStories.keys.contains("\(id)")) {
                story = topStories["\(id)"]!
            } else {
                story = hackerNews.getStory(id: top[indexPath.row])
                topStories.updateValue(story, forKey: "\(id)")
            }
            break
        default:
            break
        }
        
        
        cell?.titleLabel.text = story.title
        cell?.metaLabel.text = "\(story.by)".uppercased()
        cell?.scoreLabel.text = " \(story.score) "
        cell?.scoreLabel.sizeToFit()
        
        let frame = cell?.scoreLabel.frame
        let rect = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: (frame?.width)!*4, height: (frame?.height)!)
        
        cell?.scoreLabel.frame = rect
        
        cell?.scoreLabel.layer.cornerRadius = (cell?.scoreLabel.frame.height)!/4
        cell?.scoreLabel.layer.masksToBounds = true
        
        
        return cell!
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

}

