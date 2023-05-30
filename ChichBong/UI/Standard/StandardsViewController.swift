//
//  StandardsViewController.swift
//  ChichBong
//
//  Created by autm on 18/01/2022.
//

import UIKit
import SVProgressHUD
import QuickLook

class StandardsViewController: BaseViewController {
    @IBOutlet weak var listStandardTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearSearchBtn: UIButton!
    
    let previewController = QLPreviewController()
    
    
    let standardData = StandardData.init()
    var lstData:[DocumentObj] = []
    var lstSearchData:[DocumentObj] = []
    
    var currentUrl:NSURL?
    var previewItems: [PreviewItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        getListST()
    }
    private func setup() {
        listStandardTableView.delegate = self
        listStandardTableView.dataSource = self
        listStandardTableView.separatorStyle = .singleLine
        listStandardTableView.separatorColor = .clear
        listStandardTableView.estimatedRowHeight = 80;
        listStandardTableView.register(UINib(nibName: "StandardTableViewCell", bundle: nil), forCellReuseIdentifier: "StandardTableViewCell")
        
        self.previewController.delegate = self
        self.previewController.dataSource = self
        self.previewController.currentPreviewItemIndex = 0
        
        searchTextField.delegate = self;
    }

    private func getListST() {
        SVProgressHUD.show()
       
        lstData = []
        lstSearchData = []
        standardData.getAllStandardData { [self] documents, error in
            SVProgressHUD.dismiss()
            if documents != nil {
                lstData = documents!.Data
                lstSearchData = lstData;
                listStandardTableView.reloadData()
            } else {
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clearSearchBtnClicked(_ sender: Any) {
        self.searchTextField.text = ""
        lstSearchData = lstData;
        listStandardTableView.reloadData()
    }
    
    
    func tryToSaveFileLocal(doc: DocumentObj) {
        let fullNameArr = doc.Attachment.components(separatedBy: "####")
        if fullNameArr.count > 1 {
            currentUrl = NSURL.init(string: fullNameArr[1])
            let url = URL(string:fullNameArr[1]) ?? nil
            if url != nil {
                self.downloadFileTask(url: url!) { localUrl in
                    //

                    let docSave = Documentation.init()
                    docSave.id = doc.Id;
                    docSave.name = doc.Name;
                    docSave.dirfile = "\(localUrl!)"
                    docSave.type = DocumentType.File
                    Globalvariables.shareInstance.saveDocumentFileStatic(doc: docSave)
                }
            } else {
                self.presentAlertController(with: "Tệp tin có lỗi!")
                return;
            }
            
        } else {
            self.presentAlertController(with: "Tệp tin có lỗi!")
            return;
        }
    }
    
    func downloadFileTask(url: URL, completion: @escaping (URL?)->()) {
        SVProgressHUD.show()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                //  in case of failure to download your data you need to present alert to the user
                self.presentAlertController(with: error?.localizedDescription ?? "Failed to download the file!!!")
                completion(nil)
                return
            }
            // you neeed to check if the downloaded data is a valid pdf
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                let mimeType = httpURLResponse.mimeType
            else {
                print((response as? HTTPURLResponse)?.mimeType ?? "")
                self.presentAlertController(with: "the data downloaded it is not a valid file")
                completion(nil)
                return;
            }
            do {
                // rename the temporary file or save it to the document or library directory if you want to keep the file
                let suggestedFilename = httpURLResponse.suggestedFilename ?? "quicklook.pdf"
//                let previewURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedFilename)
                let previewURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(suggestedFilename).appendingPathExtension("pdf")
                try data.write(to: previewURL, options: .atomic)   // atomic option overwrites it if needed
//                    previewURL.hasHiddenExtension = true
                SVProgressHUD.dismiss()
                completion(previewURL)
            } catch {
                SVProgressHUD.dismiss();
                self.presentAlertController(with: "the data downloaded it is not a valid file")
                completion(nil)
            }
        }.resume()
    }
}

extension StandardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstSearchData.count
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // download
        let download = UIContextualAction(style: .normal, title: "Download") { [self] (action, view, completionHandler) in
            print("Download: \(indexPath.row)")
            
            let item = lstSearchData[indexPath.row]
            tryToSaveFileLocal(doc: item)
            
            tableView.reloadData()
            completionHandler(true)
        }
        download.image = UIImage(systemName: "arrow.down")
        download.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [download])
        
        return swipe
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let item = lstSearchData[indexPath.row]
//            Globalvariables.shareInstance.saveDocumentFileStatic(doc: item)
//            tableView.reloadData()
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardTableViewCell", for: indexPath) as! StandardTableViewCell

        let item = lstSearchData[indexPath.row]
        
        cell.titleLbl.text = item.Name
        
        let fullNameArr = item.Attachment.components(separatedBy: "####")
        if fullNameArr.count > 1 {
            cell.fileNameLbl.text = fullNameArr[0]
        } else {
            cell.fileNameLbl.text = item.Attachment
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let item = lstSearchData[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        
        let fullNameArr = item.Attachment.components(separatedBy: "####")
        if fullNameArr.count > 1 {
//            cell.fileNameLbl.text = fullNameArr[0]
            currentUrl = NSURL.init(string: fullNameArr[1])
            
            let url = URL(string:fullNameArr[1])!
            quickLook(url: url)
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Tệp tin có lỗi!", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            if ( UIDevice.current.userInterfaceIdiom == .pad )
            {
                if let popoverPresentationController = alert.popoverPresentationController {
                    let cell = tableView.cellForRow(at: indexPath)
                    popoverPresentationController.sourceView = cell! as UIView
                    popoverPresentationController.sourceRect = cell?.bounds ?? self.view.bounds
                }
            }
            
            return;
        }
    }
    
    func quickLook(url: URL) {
        SVProgressHUD.show()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                //  in case of failure to download your data you need to present alert to the user
                self.presentAlertController(with: error?.localizedDescription ?? "Failed to download the file!!!")
                return
            }
            // you neeed to check if the downloaded data is a valid pdf
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                let mimeType = httpURLResponse.mimeType
            else {
                print((response as? HTTPURLResponse)?.mimeType ?? "")
                self.presentAlertController(with: "the data downloaded it is not a valid file")
                return
            }
            do {
                // rename the temporary file or save it to the document or library directory if you want to keep the file
                let suggestedFilename = httpURLResponse.suggestedFilename ?? "quicklook.pdf"
                var previewURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedFilename)
                try data.write(to: previewURL, options: .atomic)   // atomic option overwrites it if needed
//                    previewURL.hasHiddenExtension = true
                let previewItem = PreviewItem()
                previewItem.previewItemURL = previewURL
                self.previewItems.removeAll()
                self.previewItems.append(previewItem)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.previewController.reloadData()
                    self.present(self.previewController, animated: true)
                 }
            } catch {
                SVProgressHUD.dismiss();
                self.presentAlertController(with: "the data downloaded it is not a valid file")
                print(error)
                return
            }
        }.resume()
           
    }
}


// MARK: - QLPreviewControllerDataSource
extension StandardsViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
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
                    popoverPresentationController.sourceRect = self.view.bounds
                }
            }
            
            self.present(alert, animated: true)
        }
    }
}

extension StandardsViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // search filter
        let searchKey = textField.text ?? ""
        if searchKey == "" {
            self.clearSearchBtnClicked(self.clearSearchBtn as Any)
        } else {
            lstSearchData = lstData.filter{($0.Name.lowercased().contains(searchKey.lowercased()))}
            self.listStandardTableView.reloadData()
        }
        self.view.endEditing(true)
        return true;
        
    }
}
