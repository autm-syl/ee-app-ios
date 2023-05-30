//
//  HeaderNewsPageView.swift
//  ChichBong
//
//  Created by Sylvanas on 4/26/21.
//

import UIKit

protocol HeaderNewsPageViewDelegate: AnyObject {
    func didOpenNews(newsId: NewsObj)
}

class HeaderNewsPageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var gradientView: Gradient!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeCreate: UILabel!
    
    weak var delegate:HeaderNewsPageViewDelegate?
    
    var thisNews:NewsObj?
    
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
        delegate?.didOpenNews(newsId: thisNews!)
    }
    
    public func setNews(news: NewsObj) {
        thisNews = news
        thumbnail.sd_setImage(with: URL.init(string: "\(news.thumbnail)"), completed: nil)
        name.text = news.title
        timeCreate.text = news.updated_at
    }
}
