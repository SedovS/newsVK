//
//  Parser.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//


import UIKit

class Parser {
    
    let session = URLSession.shared
    //let urlString = "https://api.vk.com/method/newsfeed.get?count=1&start_from=&max_photos=1&access_token=9b53110f1ad14839f78e8ae7f7d8ee05b39d5a94f995d23ea7a9c5f1ddedd01bad931ffac092d4a1ed10c&v=5.103"
    
     private func getUrl() -> URL {
        //https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=VERSION
        let methodName = "newsfeed.get"
        let startFrom = UserDefaults.standard.string(forKey: "nextFrom") ?? ""
        let count = 10
        let maxPhotos = 1
        let parameters = "filters=post&count=\(count)&start_from=\(startFrom)&max_photos=\(maxPhotos)"
        let version = "5.103"
        let token = UserDefaults.standard.string(forKey: "accessToken")!
        let urlString =  "https://api.vk.com/method/\(methodName)?\(parameters)&access_token=\(token)&v=\(version)"
        let url = URL(string: urlString)
        return url!
        
    }
    
    public func parsNews(tableView: UITableView) -> Void {
        let url = getUrl()
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("parsNews() error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("parsNews() statusCode should be 2xx, but is \(response.statusCode)")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let structJsonVK = try decoder.decode(StructJsonVK.self, from: data)
                self.conversionNews(structVK: structJsonVK, tableView: tableView)
                UserDefaults.standard.set(structJsonVK.response.nextFrom, forKey: "nextFrom")
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            } catch {
                print("parsNews() error parser do-catch -> \(error.localizedDescription)")
            }
        } .resume()
    }
    
    func parsImage(tableView: UITableView, urlString : String) -> Void {
        guard let url = URL(string: urlString) else {return}
        var image = UIImage()
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("parsImage() error", error ?? "Unknown error")
                return
            }
            image = UIImage(data: data)!
            globaldictionaryCasheImege.setObject(image, forKey: NSString(string: "\(url)"))
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        } .resume()
    }
        
    private func conversionNews(structVK: StructJsonVK, tableView: UITableView) -> Void {
 
        for item in structVK.response.items {
            guard let arrayAttachments = item.attachments else {
                continue
            }
            var urlPhoto = ""
            var width = 0
            var height = 0
            guard let photo = arrayAttachments[0].photo else {
                break
            }
            for size in photo.sizes {
                if size.type == "y" {
                    urlPhoto = size.url
                    width = size.width
                    height = size.height
                    break
                }
                urlPhoto = size.url
                width = size.width
                height = size.height
            }
            
            parsImage(tableView: tableView, urlString: urlPhoto)
            globalArrayNews.append(News(text: item.text ?? "", urlPhoto: urlPhoto, width: width, height: height))
            
        }        
    }
    
}
    
