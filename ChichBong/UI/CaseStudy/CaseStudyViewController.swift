//
//  OrderCheckViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/23/21.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class CaseStudyViewController: BaseViewController {
    @IBOutlet weak var collectionCS: UICollectionView!
    
    var refresher:UIRefreshControl!
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    
    let caseStudyData = CaseStudyData.init()
    var lstData:[DocumentObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getListCS()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    private func setup() {
        self.refresher = UIRefreshControl()
        self.collectionCS!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(reloadNewsCollectionData), for: .valueChanged)
        self.collectionCS!.addSubview(refresher)
        
        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionCS.collectionViewLayout = layoutmain
        collectionCS.delegate = self
        collectionCS.dataSource = self
        collectionCS.register(UINib(nibName: "QACollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QACollectionViewCell")
    }
    
    @objc func reloadNewsCollectionData() {
        refresher.beginRefreshing()
        
        getListCS()
    }
    
    func getListCS() {
        lstData = []
        caseStudyData.getAllCaseStudyData { [self] documents, error in
            if documents != nil {
                lstData = documents!.Data
                collectionCS.reloadData()
                refresher.endRefreshing()
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

    @IBAction func menuCicked(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    @IBAction func createNewBtnClicked(_ sender: Any) {
        let csViewController = CreateCaseStudyViewController(nibName: "CreateCaseStudyViewController", bundle: nil)
        csViewController.delegate = self
        self.navigationController?.pushViewController(csViewController, animated: true)
    }
    
    func ShowBottomToastWith(title: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        self.view.makeToast(title, duration: 3.5, position: .bottom, style: style)
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }
   
}
extension CaseStudyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return lstData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QACollectionViewCell", for: indexPath) as! QACollectionViewCell
        
        let item = lstData[indexPath.row]
        
        cell.nameLbl.text = item.Name
        let text = Util.share.matchesReplaceHtml(in: item.Content)
        cell.contentLbl.text = text
        cell.contentLbl.numberOfLines = 12;
        cell.createByLbl.text = "\(item.Created_by_name ?? "none")"
        cell.createAtLbl.text = "\(item.Created_at)"
        cell.moreBtnLbl.setTitle("Trả lời >", for: .normal)
        cell.delegate = self
        cell.thisCellIndex = indexPath.row
        cell.contentHeightConstraints.constant = 150
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(2 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(2)).rounded(.down)
        
        return CGSize(width: itemWidth, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let item = lstData[indexPath.row]

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let reamlObj = Documentation()
            reamlObj.id = item.Id
            reamlObj.name = item.Name
            reamlObj.content = item.Content
            reamlObj.dirfile = ""
            reamlObj.created = Date()
            reamlObj.type = DocumentType.CaseStudy
            
            
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://45.76.156.52/document-view/\(item.Id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.Name
            newsController.documentype = DocumentType.CaseStudy
            newsController.reamlDocument = reamlObj
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}

extension CaseStudyViewController:QACollectionViewCellDelegate {
    func readMoreBtnClicked(index: Int) {
        let item = lstData[index]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let reamlObj = Documentation()
            reamlObj.id = item.Id
            reamlObj.name = item.Name
            reamlObj.content = item.Content
            reamlObj.dirfile = ""
            reamlObj.created = Date()
            reamlObj.type = DocumentType.CaseStudy
            
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://45.76.156.52/document-view/\(item.Id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.Name
            newsController.documentype = DocumentType.CaseStudy
            newsController.reamlDocument = reamlObj
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}

extension CaseStudyViewController:CreateCaseStudyViewControllerDelegate {
    func createCastudySuccess() {
        getListCS()
    }
}
