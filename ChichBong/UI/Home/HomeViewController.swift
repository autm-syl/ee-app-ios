//
//  HomeViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import UIKit
import ViewAnimator
import SwiftEntryKit
import SVProgressHUD
import Combine
import CombineCocoa



class HomeViewController: UIViewController {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var rootCategoryCollection: UICollectionView!
    
    var refresher:UIRefreshControl!
    let inset: CGFloat = 5
    let minimumLineSpacing: CGFloat = 2
    let minimumInteritemSpacing: CGFloat = 2
    
    var data:[CategoryTreeData] = []
    let homeData = HomeViewData.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupView()
        getAllCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getAllCategories() {
        SVProgressHUD.show()
        homeData.getAllCategory { [self] dataResult, error in
            //
            SVProgressHUD.dismiss()
            print("dataResult", dataResult)
            if error == nil && dataResult.count > 0 {
                data = dataResult[0]!.children
            }
            self.rootCategoryCollection.reloadData()
            refresher.endRefreshing()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
   
    @IBAction func menuClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    
    
    func setupView() {
        self.refresher = UIRefreshControl()
        self.rootCategoryCollection!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(reloadNewsCollectionData), for: .valueChanged)
        self.rootCategoryCollection!.addSubview(refresher)
        
        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        rootCategoryCollection.collectionViewLayout = layoutmain
        rootCategoryCollection.delegate = self
        rootCategoryCollection.dataSource = self
        rootCategoryCollection.register(UINib(nibName: "RootCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RootCategoryCollectionViewCell")
    }
    
    @objc func reloadNewsCollectionData() {
        refresher.beginRefreshing()
        
        getAllCategories()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RootCategoryCollectionViewCell", for: indexPath) as! RootCategoryCollectionViewCell
        
        let item = data[indexPath.row]
        let imageDefault = #imageLiteral(resourceName: "not_finishIcon")
        cell.cateIcon.sd_setImage(with: URL.init(string: item.description), placeholderImage: imageDefault, options: .progressiveLoad, progress: nil, completed: nil)
        cell.cateName.text = item.name
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 3 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(3 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(3)).rounded(.down)
        
        return CGSize(width: itemWidth, height: itemWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let item = data[indexPath.row]

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let subItem:[CategoryTreeData] = item.children
            let detailRootCategoryController = DetailRootCategoryViewController(nibName: "DetailRootCategoryViewController", bundle: nil)
            detailRootCategoryController.data = subItem;
            self.navigationController?.pushViewController(detailRootCategoryController, animated: true)
        }
    }
}
