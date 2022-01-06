//
//  CategoriesViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import UIKit

import ViewAnimator
import SwiftEntryKit
import SVProgressHUD
import Alamofire

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchViewZone: UIView!
    @IBOutlet weak var filterListBtn: UIButton!
    @IBOutlet weak var clearTextBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var itemCollection: UICollectionView!
    
    
    
    var initiallyAnimates = true
    private let animations = [AnimationType.vector(CGVector.init(dx: 0, dy: 0)), AnimationType.zoom(scale: 0.01), AnimationType.rotate(angle: 0)]
    let inset: CGFloat = 15
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    
    let searchViewData = SearchViewData.init()
    var dataTableResult:[DocumentObj] = []
    
    var curentDocTypeSearch = DocumentType.html
    
    //for load more
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting collection
        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemCollection.collectionViewLayout = layoutmain
        itemCollection.delegate = self
        itemCollection.dataSource = self
        itemCollection.register(UINib(nibName: "ProductNewCell", bundle: nil), forCellWithReuseIdentifier: "ProductNewCell")
        
        // setting search
        searchViewZone.layer.cornerRadius = 6.0
        searchViewZone.layer.masksToBounds = true

        searchField.delegate = self
        searchField.placeholder = "Tìm kiếm bài viết"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    
    @IBAction func filterBtnClicked(_ sender: Any) {
        let sheetChooseTypeSearch = UIAlertController(title: "Select type", message: "Chọn kiểu dữ liệu muốn tìm kiếm", preferredStyle: .actionSheet)
        sheetChooseTypeSearch.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            sheetChooseTypeSearch.dismiss(animated: true, completion: nil)
        }))
        sheetChooseTypeSearch.addAction(UIAlertAction(title: "Document", style: .default, handler: { [self] action in
            curentDocTypeSearch = DocumentType.html
            searchField.text = ""
            searchField.placeholder = "Tìm kiếm bài viết"
            sheetChooseTypeSearch.dismiss(animated: true, completion: nil)
        }))
        sheetChooseTypeSearch.addAction(UIAlertAction(title: "Q&A", style: .default, handler: { [self]
            action in
            curentDocTypeSearch = DocumentType.QA
            searchField.text = ""
            searchField.placeholder = "Tìm kiếm Q&A"
            sheetChooseTypeSearch.dismiss(animated: true, completion: nil)
        }))
        sheetChooseTypeSearch.addAction(UIAlertAction(title: "CaseStudy", style: .default, handler: { [self]
            action in
            curentDocTypeSearch = DocumentType.CaseStudy
            searchField.text = ""
            searchField.placeholder = "Tìm kiếm CaseStudy"
            sheetChooseTypeSearch.dismiss(animated: true, completion: nil)
        }))
        sheetChooseTypeSearch.addAction(UIAlertAction(title: "File", style: .default, handler: { [self]
            action in
            curentDocTypeSearch = DocumentType.File
            searchField.text = ""
            searchField.placeholder = "Tìm kiếm File"
            sheetChooseTypeSearch.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(sheetChooseTypeSearch, animated: true, completion: nil)
    }
    @IBAction func clearTextBtnClicked(_ sender: Any) {
        searchField.text = ""
        dataTableResult = []
        itemCollection.reloadData()
    }
    
    func searchProduct(query:String) {
        SVProgressHUD.show()
        searchViewData.searchDocumentation(queryName: query, documentType: curentDocTypeSearch) { [self] documents, error in
            //
            SVProgressHUD.dismiss()
            if documents != nil {
                dataTableResult = documents!.Data
                itemCollection.reloadData()
            }
        }
    }
}


extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return dataTableResult.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductNewCell", for: indexPath) as! ProductNewCell
        
        let item = dataTableResult[indexPath.row]
        let text = Util.share.matchesReplaceHtml(in: item.Content)
        cell.productName.text = item.Name
        cell.productDes.text = text
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 1 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(1 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
        
        return CGSize(width: itemWidth, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        
        let item = dataTableResult[indexPath.row]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let reamlObj = Documentation()
            reamlObj.id = item.Id
            reamlObj.name = item.Name
            reamlObj.content = item.Content
            reamlObj.dirfile = ""
            reamlObj.created = Date()
            reamlObj.type = item.Doc_type
            
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://3.16.29.132/document-view/\(item.Id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.Name
            newsController.documentype = item.Doc_type
            newsController.reamlDocument = reamlObj
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        let query = textField.text
        if (query != "") {
            searchProduct(query: query!)
        }
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let query = textField.text
        if (query != "") {
            searchProduct(query: query!)
        }
        return true
    }
}



import ObjectMapper

class CategoriesResult: Mappable {
    var categories:[CategoryObj] = []
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        categories <- map["Data.Categories"]
    }
}

class CategoryObj: Mappable {
    var id = 0;
    var name = "";
    var description = "";
    var parent_cate_id = "";
    var thumbnail = "";
    var status = 0;
    var Children_cate:[CategoryObj] = [];
    var ordinal = 0
    var totalItem = 0
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        id <- map["Id"];
        name <- map["Name"];
        description <- map["Description"];
        parent_cate_id <- map["Parent_cate_id"];
        thumbnail <- map["Thumbnail"];
        status <- map["Status"];
        Children_cate <- map["Children_cate"];
        ordinal <- map["Ordinal"];
        totalItem <- map["TotalItem"];
    }
}
