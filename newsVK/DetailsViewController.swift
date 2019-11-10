//
//  DetailsViewController.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Foundation

class DetailsViewController: UIViewController {

    var news: News!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicView()
       
    }
    
    private func dynamicView() -> Void {
        let scrolView = UIScrollView()
        let widthScrolView = view.frame.width
        let heightScrolView = view.frame.height
        let contentView = UIView()
        let wightPhoto = news.width
        let heightPhoto = news.height
        let proportion = CGFloat(wightPhoto) / CGFloat(heightPhoto)
        let width = widthScrolView - 20
        var height = width / proportion
      
        imageView.frame = CGRect(x: 10, y: 10, width: width, height: height)
        imageView.image = globaldictionaryCasheImege.object(forKey: news!.urlPhoto as NSString)
        height += 30
        
        let text = news.text
        textLabel.frame = CGRect(x: 20, y: height, width: width - 20, height: 10)
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: CGFloat(18))
        textLabel.textAlignment = .center
        textLabel.text = text
        textLabel.sizeToFit()
    
        height += textLabel.frame.height
        height += 50
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        
        scrolView.frame = CGRect(x: 0, y: 0, width: widthScrolView, height: heightScrolView)
        contentView.frame = CGRect(x: 0, y: 0, width: widthScrolView, height: height)
        
        scrolView.contentSize.height = contentView.frame.height
        scrolView.addSubview(contentView)
        view.addSubview(scrolView)
    }

}
