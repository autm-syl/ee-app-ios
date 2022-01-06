//
//  NewsListViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/26/21.
//

import UIKit
import ViewAnimator
import SwiftEntryKit
import SVProgressHUD

class NewsListViewController: UIViewController {
    @IBOutlet weak var savedDataTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocalFile()
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkLocalFile() {
        if Globalvariables.shareInstance.documentsLocal != nil {
            savedDataTable.delegate = self
            savedDataTable.dataSource = self
            savedDataTable.separatorStyle = .singleLine
            savedDataTable.separatorColor = .clear
            savedDataTable.estimatedRowHeight = 100;
            savedDataTable.register(UINib(nibName: "DataSavedTableViewCell", bundle: nil), forCellReuseIdentifier: "DataSavedTableViewCell")
            savedDataTable.reloadData()
        }
    }
}


extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globalvariables.shareInstance.documentsLocal!.count
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = Globalvariables.shareInstance.documentsLocal![indexPath.row]
            Globalvariables.shareInstance.removeDocument(doc: item)
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataSavedTableViewCell", for: indexPath) as! DataSavedTableViewCell

        let item = Globalvariables.shareInstance.documentsLocal![indexPath.row]
        switch item.type{
        case DocumentType.html:
            cell.iconType.image = #imageLiteral(resourceName: "icon_document")
            break
        case DocumentType.File:
            cell.iconType.image = #imageLiteral(resourceName: "icon_file")
            break
        case DocumentType.CaseStudy:
            cell.iconType.image = #imageLiteral(resourceName: "icon_caseStudy")
            break
        default:
            cell.iconType.image = #imageLiteral(resourceName: "Default")
            break
        }
        
        cell.titleLbl.text = item.name
        cell.sortDescription.text = Util.share.matchesReplaceHtml(in: item.content)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        cell.timeSave.text = dateFormatter.string(from: item.created)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let item = Globalvariables.shareInstance.documentsLocal![indexPath.row]
        
        if MonConnection.isConnectedToInternet() {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                
                let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
                newsController.staticLink = "http://3.16.29.132/document-view/\(item.id)?token=\(Globalvariables.shareInstance.token_auth)"
                newsController.headerTitleSet = item.name
                newsController.documentype = item.type
                newsController.reamlDocument = item
                self.navigationController?.pushViewController(newsController, animated: true)
            }
        } else {
            let newsController = WebViewStaticHTMLViewController(nibName: "WebViewStaticHTMLViewController", bundle: nil)
            newsController.contentHtmlString = item.content
            newsController.headerTitleSet = item.name
            self.navigationController?.pushViewController(newsController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
