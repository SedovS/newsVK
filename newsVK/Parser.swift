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
    //let urlString = "https://api.vk.com/method/newsfeed.get?filters=post&count=10&start_from=221/5_-36338110_436573:1693208936&max_photos=1&access_token=6fef31ee2da6ea865faf721bde782157efc77f417d52cdb8f7f185370e4d01a158ebe122cd6b827c3b367&v=5.103"
    
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
        //let url = URL(string: urlString)
        
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
    
