//
//  HeaderNewsPageView.swift
//  ChichBong
//
//  Created by Sylvanas on 4/26/21.
//

import UIKit

protocol HeaderNewsPageViewDelegate: AnyObject {
    func didOpenNews(newsId: Int)
}

class HeaderNewsPageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var gradientView: Gradient!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeCreate: UILabel!
    
    weak var delegate:HeaderNewsPageViewDelegate?
    
    var newsId = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderNewsPageView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
    }

    @IBAction func didClickedOpenthisNews(_ sender: Any) {
        delegate?.didOpenNews(newsId: newsId)
    }
    
    public func setNews(news: DocumentObj) {
//        newsId = news.Id
//        thumbnail.sd_setImage(with: URL.init(string: "\(news.Thumbnail)"), completed: nil)
//        name.text = news.Name
//        let date = Date(timeIntervalSince1970: TimeInterval(news.Create_time))
//        timeCreate.text = "\(date.getElapsedInterval())"
    }
}
