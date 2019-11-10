//
//  NewsTableViewController.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var loadingNews = false //грузятся ли новости
    let parser = Parser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parser.parsNews(tableView: self.tableView)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        loadingNews = false
        return globalArrayNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsItem", for: indexPath) as! NewsTableViewCell
        tableView.rowHeight = 280
        
        cell.newsLabel.text = globalArrayNews[indexPath.row].text
        if let image = globaldictionaryCasheImege.object(forKey: NSString(string: globalArrayNews[indexPath.row].urlPhoto)) {
            cell.newsImage.image = image
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = globalArrayNews[indexPath.row]
        self.performSegue(withIdentifier: "segueNewstoDetails", sender: news)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailsViewController {
            controller.news = sender as! News
        }
    }
    
    //MARK: helpFunctions
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !loadingNews {
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        loadingNews = true
        if globalArrayNews.count != 0 {
            parser.parsNews(tableView: self.tableView)
        }
    }
    

}
