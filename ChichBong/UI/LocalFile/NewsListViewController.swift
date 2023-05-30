//
//  NewsListViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/26/21.
//

import UIKit
import ViewAnimator
import SwiftEntryKit
import QuickLook
import SVProgressHUD
import RealmSwift


class NewsListViewController: UIViewController {
    @IBOutlet weak var savedDataTable: UITableView!
    let previewController = QLPreviewController()
    var previewItems: [PreviewItem] = []
    
    var localFiles: Results<Documentation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocalFile()
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkLocalFile() {
        localFiles = Globalvariables.shareInstance.GetDocSave()
        if localFiles != nil {
            savedDataTable.delegate = self
            savedDataTable.dataSource = self
            savedDataTable.separatorStyle = .singleLine
            savedDataTable.separatorColor = .clear
            savedDataTable.estimatedRowHeight = 100;
            savedDataTable.register(UINib(nibName: "DataSavedTableViewCell", bundle: nil), forCellReuseIdentifier: "DataSavedTableViewCell")
            savedDataTable.reloadData()
            
            
            self.previewController.delegate = self
            self.previewController.dataSource = self
            self.previewController.currentPreviewItemIndex = 0
        }
    }
}


extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localFiles!.count
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = localFiles![indexPath.row]
            Globalvariables.shareInstance.removeDocument(doc: item)
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataSavedTableViewCell", for: indexPath) as! DataSavedTableViewCell

        let item = localFiles![indexPath.row]
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
        if (item.type == DocumentType.File) {
            cell.titleLbl.text = item.name
            cell.sortDescription.text = "Tiêu chuẩn"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            cell.timeSave.text = dateFormatter.string(from: item.created)
            return cell
        } else {
            cell.titleLbl.text = item.name
            cell.sortDescription.text = Util.share.matchesReplaceHtml(in: item.content)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            cell.timeSave.text = dateFormatter.string(from: item.created)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let item = localFiles![indexPath.row]
        
        if item.type == DocumentType.File {
            let previewItem = PreviewItem()
            previewItem.previewItemURL = URL(string: item.dirfile)
            self.previewItems.removeAll()
            self.previewItems.append(previewItem)
            DispatchQueue.main.async {
                self.previewController.reloadData()
                self.present(self.previewController, animated: true)
             }
        } else {
            if MonConnection.isConnectedToInternet() {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                    
                    let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
                    newsController.staticLink = "http://45.76.156.52/document-view/\(item.id)?token=\(Globalvariables.shareInstance.token_auth)"
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
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - QLPreviewControllerDataSource
extension NewsListViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { previewItems.count }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem { previewItems[index] }
    func presentAlertController(with message: String) {
         // present your alert controller from the main thread
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            
            if ( UIDevice.current.userInterfaceIdiom == .pad )
            {
                if let popoverPresentationController = alert.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
                }
            }
            
            self.present(alert, animated: true)
        }
    }
}
