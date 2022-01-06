//
//  AllNewsViewController.swift
//  ChichBong
//
//  Created by autm on 06/01/2022.
//

import UIKit
import SVProgressHUD
import SwiftEntryKit
import ViewAnimator
import ParallaxHeader

class AllNewsViewController: UIViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var topView: HeaderNewsPageView!
    var refresher:UIRefreshControl!
    
    var initiallyAnimates = true
    private let animations = [AnimationType.vector(CGVector.init(dx: 0, dy: 0)), AnimationType.zoom(scale: 0.01), AnimationType.rotate(angle: 0)]
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    
    var newsCollectionData:[DocumentObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refresher = UIRefreshControl()
        self.mainCollectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(reloadNewsCollectionData), for: .valueChanged)
        self.mainCollectionView!.addSubview(refresher)

        setupTopCollection()
        loadNewsDataCollection {
            // none
        }
    }
    
    @objc func reloadNewsCollectionData() {
        refresher.beginRefreshing()
        
        loadNewsDataCollection { [self] in
            //
            refresher.endRefreshing()
        }
    }
    
    
    func setupTopCollection() {
        var dto:CGFloat
        dto = (view.frame.height) / 2
        
        if dto < 400 {
            dto = 400
        }

        self.topView = HeaderNewsPageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.view.frame.size.width, height: dto)));
        self.topView.delegate = self

        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        mainCollectionView.collectionViewLayout = layoutmain
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
//        newsCollectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsCollectionViewCell")
        mainCollectionView.parallaxHeader.view = self.topView
        mainCollectionView.parallaxHeader.height = dto
        mainCollectionView.parallaxHeader.minimumHeight = 0
        mainCollectionView.parallaxHeader.mode = .centerFill
        mainCollectionView.parallaxHeader.parallaxHeaderDidScrollHandler = { [self] parallaxHeader in
            //update alpha of blur view on top of image view
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            
            print("thong so ",parallaxHeader.height, parallaxHeader.progress)
            if (parallaxHeader.progress == 0) {
//                vibrantButton.isHidden = false
            } else {
//                vibrantButton.isHidden = true
            }
        }
        self.mainCollectionView.performBatchUpdates({
            UIView.animate(views: self.mainCollectionView.orderedVisibleCells,
                           animations: animations, completion: {
                            //
                })
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func menuBtnClicked(_ sender: Any) {
    }
    
    
    func loadNewsDataCollection(completionNewsdata: @escaping () -> Void) {
//        MonConnection.requestCustom(APIRouter.getNews(newsId: -1)) { [self] (result, error) in
//            if error == nil {
//                // xu ly result
//                let news_result = ListNewsResult.init(JSON: result!)
//                
//                guard let news = news_result?.news else {
//                    // no live header.
//                    completionNewsdata()
//                    return;
//                }
//                
//                let lstOldItem = news;
//                let lstNewItem = lstOldItem.sorted {
//                    $0.Ordinal < $1.Ordinal
//                }
//                
//                let topNews = lstNewItem[0]
//                self.topView.setNews(news: topNews)
//                
//                newsCollectionData = Array(lstNewItem.dropFirst())
//                newsCollectionView.reloadData()
//                self.newsCollectionView.performBatchUpdates({
//                    UIView.animate(views: self.newsCollectionView.orderedVisibleCells,
//                                   animations: animations, completion: {
//                                    //
//                        })
//                }, completion: nil)
//                completionNewsdata()
//            } else {
//                // loi
//                // no live header.
//                completionNewsdata()
//            }
//        }
    }
}

extension AllNewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return minimumLineSpacing
   }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return minimumInteritemSpacing
   }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return newsCollectionData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        
        let item = newsCollectionData[indexPath.row]

//        cell.thumbnail.sd_setImage(with: URL.init(string: item.Thumbnail), placeholderImage: UIImage.init(named: "ImageDefault"), options: .progressiveLoad, progress: nil, completed: nil)
//
//        cell.name.text = item.Name
//
//        let date = Date(timeIntervalSince1970: TimeInterval(item.Create_time))
//        cell.timecreate.text = "\(date.getElapsedInterval())"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 3 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(3 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(3)).rounded(.down)
        
        return CGSize(width: itemWidth, height: itemWidth * 2 + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let item = newsCollectionData[indexPath.row]

//        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
//        newsController.newsId = item.Id
//        newsController.headerTitleSet = item.Name
//        self.navigationController?.pushViewController(newsController, animated: true)
    }
}
extension AllNewsViewController: HeaderNewsPageViewDelegate {
    func didOpenNews(newsId: Int) {
        //
//        let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
//        newsController.newsId = newsId
//        newsController.headerTitleSet = "Tin tức"
//        self.navigationController?.pushViewController(newsController, animated: true)
    }
}

