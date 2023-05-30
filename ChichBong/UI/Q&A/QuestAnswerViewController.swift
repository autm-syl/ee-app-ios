//
//  WishListViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/20/21.
//

import UIKit

class QuestAnswerViewController: BaseViewController {
    @IBOutlet weak var createNew: UIButton!
    @IBOutlet weak var collectionQA: UICollectionView!
    
    var refresher:UIRefreshControl!
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    
    let QAdata = QAViewData.init()
    
    var lstData:[DocumentObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getListQA()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setup() {
        self.refresher = UIRefreshControl()
        self.collectionQA!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(reloadNewsCollectionData), for: .valueChanged)
        self.collectionQA!.addSubview(refresher)
        
        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layoutmain.scrollDirection = .horizontal
        collectionQA.collectionViewLayout = layoutmain
        collectionQA.delegate = self
        collectionQA.dataSource = self
        collectionQA.register(UINib(nibName: "QACollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QACollectionViewCell")
    }
    
    @objc func reloadNewsCollectionData() {
        refresher.beginRefreshing()
        
        getListQA()
    }
    
    func getListQA() {
        lstData = []
        QAdata.getAllQAData { [self] documents, error in
            if documents != nil {
                lstData = documents!.Data
                collectionQA.reloadData()
                
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

    @IBAction func menuClick(_ sender: Any) {
        NotificationCenter.default.post(name:.toggleLeftMenu, object: nil);
    }
    @IBAction func createNewBtnClicked(_ sender: Any) {
        let newQAViewController = CreateNewQAViewController(nibName: "CreateNewQAViewController", bundle: nil)
        newQAViewController.delegate = self
        self.navigationController?.pushViewController(newQAViewController, animated: true)
    }
    
}

extension QuestAnswerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        cell.contentLbl.numberOfLines = 6;
        cell.createByLbl.text = "\(item.Created_by_name ?? "none")"
        cell.createAtLbl.text = "\(item.Created_at)"
        cell.moreBtnLbl.setTitle("Trả lời >", for: .normal)
        cell.delegate = self
        cell.thisCellIndex = indexPath.row
        cell.contentHeightConstraints.constant = 100
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(2 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(2)).rounded(.down)
        
        return CGSize(width: itemWidth, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let item = lstData[indexPath.row]

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://45.76.156.52/document-view/\(item.Id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.Name
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}

extension QuestAnswerViewController:QACollectionViewCellDelegate {
    func readMoreBtnClicked(index: Int) {
        let item = lstData[index]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            let newsController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            newsController.staticLink = "http://45.76.156.52/document-view/\(item.Id)?token=\(Globalvariables.shareInstance.token_auth)"
            newsController.headerTitleSet = item.Name
            self.navigationController?.pushViewController(newsController, animated: true)
        }
    }
}


extension QuestAnswerViewController: CreateNewQAViewControllerDelegate {
    func createNewQASuccess() {
        getListQA()
    }
}
