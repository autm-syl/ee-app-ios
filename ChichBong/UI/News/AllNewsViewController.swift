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
import DropDown
import Toast_Swift

class AllNewsViewController: BaseViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var categoriesViews: UIView!
    
    var topView: HeaderNewsPageView!
    var refresher:UIRefreshControl!
    
    var initiallyAnimates = true
    private let animations = [AnimationType.vector(CGVector.init(dx: 0, dy: 0)), AnimationType.zoom(scale: 0.01), AnimationType.rotate(angle: 0)]
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    
    var newsCollectionData:[NewsObj] = []
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refresher = UIRefreshControl()
        self.mainCollectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(reloadNewsCollectionData), for: .valueChanged)
        self.mainCollectionView!.addSubview(refresher)

        setupTopCollection()
        var cate = currentCategory.text;
        if cate == "" || cate == "All" {
            cate = ""
        }
        loadNewsDataCollection(cateName: cate ?? "", completionNewsdata: { [self] in
            //
            refresher.endRefreshing()
        })
        
        getAllNewsCategory()
    }
    
    @objc func reloadNewsCollectionData() {
        refresher.beginRefreshing()
        var cate = currentCategory.text;
        if cate == "" || cate == "All" {
            cate = ""
        }
        loadNewsDataCollection(cateName: cate ?? "", completionNewsdata: { [self] in
            //
            refresher.endRefreshing()
        })
    }
    
    func setupListCategoriesNews(lst: [String]) {
        var dto:[String] = lst.filter { item in
            return item != ""
        }
        dto.insert(contentsOf: ["All"], at: 0)
        
        self.categoriesViews.isHidden = false;
        dropDown.anchorView = categoriesViews
        dropDown.dataSource = dto
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            if index == 0 {
                loadNewsDataCollection(cateName: "", completionNewsdata: nil)
                self.currentCategory.text = "All"
            } else {
                self.currentCategory.text = item
                loadNewsDataCollection(cateName: item, completionNewsdata: nil)
            }
            dropDown.hide()
        }

        // Will set a custom width instead of the anchor view width
        dropDown.width = 200
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

    func getAllNewsCategory() {
        MonConnection.requestCustom(APIRouter.getAllNewsCategories) { [self] result, error in
            //
            if error == nil {
                let newscategories_result = CategoryNewsResult.init(JSON: result!)
                
                let categoriesNews = newscategories_result!.categories
                
                if categoriesNews.count > 0 {
                    self.setupListCategoriesNews(lst: categoriesNews)
                }
            }
        }
    }
   
    @IBAction func menuBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    @IBAction func chooseCategoryBtnClicked(_ sender: Any) {
        dropDown.show()
    }
    
    
    func loadNewsDataCollection(cateName:String, completionNewsdata: (() -> Void)? = nil) {
        SVProgressHUD.show()
        MonConnection.requestCustom(APIRouter.get_all_news(category_name: cateName)) { [self] result, error in
            SVProgressHUD.dismiss()
            if error == nil {
                // xu ly result
                let news_result = NewsResult.init(JSON: result!)
                
                guard let news = news_result?.news else {
                    // no live header.
                    completionNewsdata?()
                    return;
                }
                
                let lstOldItem = news.filter { new1 in
                    return new1.id >= 10
                  }
                let lstNewItem = lstOldItem.sorted {
                    $0.ordinal < $1.ordinal
                }
                
                if (lstNewItem.count == 0) {
                    var style = ToastStyle.init();
                    style.messageColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    self.view.makeToast("Không có bài viết nào được tìm thấy", duration: 4.0, position: .bottom, title: "🌧", image: nil, style: style, completion: nil)
                    
                    return;
                }
                
                let topNews = lstNewItem[0]
                self.topView.setNews(news: topNews)
                
                newsCollectionData = Array(lstNewItem.dropFirst())
                mainCollectionView.reloadData()
                self.mainCollectionView.performBatchUpdates({
                    UIView.animate(views: self.mainCollectionView.orderedVisibleCells,
                                   animations: animations, completion: {
                                    //
                        })
                }, completion: nil)
                completionNewsdata?()
            } else {
                // loi
                // no live header.
                completionNewsdata?()
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
            }
        }
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
        cell.thumbnail.sd_setImage(with: URL.init(string: item.thumbnail), placeholderImage: UIImage.init(named: "ImageDefault"), options: .progressiveLoad, progress: nil, completed: nil)
        cell.name.text = item.title
        cell.timecreate.text = item.updated_at
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 3 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(3 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(3)).rounded(.down)
        
        return CGSize(width: itemWidth, height: itemWidth * 2 + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let item = newsCollectionData[indexPath.row]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://45.76.156.52/news-view/\(item.id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.title
            newsController.documentype = 1
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}

extension AllNewsViewController: HeaderNewsPageViewDelegate {
    func didOpenNews(newsId: NewsObj) {
        let newsController = WebViewStaticHTMLViewController(nibName: "WebViewStaticHTMLViewController", bundle: nil)
        newsController.contentHtmlString = newsId.content
        newsController.headerTitleSet = newsId.title
        self.navigationController?.pushViewController(newsController, animated: true)
    }
}

