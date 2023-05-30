//
//  DetailRootCategoryViewController.swift
//  ChichBong
//
//  Created by autm on 02/01/2022.
//

import UIKit
import ViewAnimator
import SwiftEntryKit
import SVProgressHUD
import Combine
import CombineCocoa

class DetailRootCategoryViewController: UIViewController {
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    let treeView:CITreeView =  CITreeView.init(frame: .zero, style: .plain)
    
    var data:[CategoryTreeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupLayout()
    }

    func setupView() {
        self.treeView.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.treeViewDelegate = self
            $0.treeViewDataSource = self
            $0.separatorColor = .clear
            $0.collapseNoneSelectedRows = true;
            $0.estimatedRowHeight = 30;
            $0.register(UINib(nibName: "CateExpandTableViewCell", bundle: nil), forCellReuseIdentifier: "CateExpandTableViewCell")
            $0.reloadData()
//            $0.expandAllRows()
        }

        self.bottomView.addSubview(self.treeView)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // title rect view
            self.treeView.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 0),
            self.treeView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 0),
            self.treeView.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor, constant: 0),
            self.treeView.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: 0)
        ])
    }

}

// MARK: Delegate
extension DetailRootCategoryViewController: CITreeViewDelegate {
    func treeView(_ treeView: CITreeView, estimatedHeightForRowAt indexPath: IndexPath, with treeViewNode: CITreeViewNode) -> CGFloat {
        let dataObj = treeViewNode.item as! CategoryTreeData
        if treeViewNode == nil {
            return 30;
        }
        
        if dataObj.isHtml == true {
            return 200;
        } else {
            return 30;
        }
    }
    
    
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, willExpandAt indexPath: IndexPath) {
        //
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, didExpandAt indexPath: IndexPath) {
        //
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, willCollapseAt indexPath: IndexPath) {
        //
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, didCollapseAt indexPath: IndexPath) {
        //
    }

    func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, at indexPath: IndexPath) {
        if let parentNode = treeViewNode.parentNode{
            print(parentNode.item)
        }
        
        let dataObj = treeViewNode.item as! CategoryTreeData
        if dataObj.isHtml == true {
            // open page
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                
                let reamlObj = Documentation()
                reamlObj.id = dataObj.docid
                reamlObj.name = dataObj.name
                reamlObj.content = dataObj.content
                reamlObj.dirfile = ""
                reamlObj.created = Date()
                reamlObj.type = DocumentType.html
                
                let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
                newsController.staticLink = "\(Config.BASE_DOCUEMNT_VIEW)/\(dataObj.docid)?token=\(Globalvariables.shareInstance.token_auth)"
                newsController.headerTitleSet = "\(dataObj.name)"
                newsController.documentype = DocumentType.html
                newsController.reamlDocument = reamlObj
                self.navigationController?.pushViewController(newsController, animated: true)
            }
        }
    }
    
    func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, at indexPath: IndexPath) {
        //
    }

}

// MARK: Datasource
extension DetailRootCategoryViewController: CITreeViewDataSource {
    
//    func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, with treeViewNode: CITreeViewNode) -> CGFloat {
//        return 30
//    }
    
    
    func treeViewSelectedNodeChildren(for treeViewNodeItem: Any) -> [Any] {
        if let dataObj = treeViewNodeItem as? CategoryTreeData {
            return dataObj.children
        }
        return []
    }
    
    func treeViewDataArray() -> [Any] {
        return data
    }
  
    func treeView(_ treeView: CITreeView, cellForRowAt indexPath: IndexPath, with treeViewNode: CITreeViewNode) -> UITableViewCell {
        let cell = treeView.dequeueReusableCell(withIdentifier: "CateExpandTableViewCell") as! CateExpandTableViewCell
        let dataObj = treeViewNode.item as! CategoryTreeData
        
        if dataObj.isHtml == true {
            let text = Util.share.matchesReplaceHtml(in: dataObj.content)
            cell.detailedLabel.text = text
            cell.setupCell(level: treeViewNode.level)
        } else {
            cell.detailedLabel.text = dataObj.name
            cell.setupCell(level: treeViewNode.level)
        }
        
        cell.iconImg.isHidden = true
        
        return cell;
    }

}
