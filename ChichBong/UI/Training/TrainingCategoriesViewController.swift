//
//  TrainingCategoriesViewController.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class TrainingCategoriesViewController: UIViewController {
    @IBOutlet weak var categoriesQuestTable: UITableView!
    
    let traingData = TrainingData.init()
    var lstData:[QuestCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        getListQS()
    }


    private func setup() {
        categoriesQuestTable.delegate = self
        categoriesQuestTable.dataSource = self
        categoriesQuestTable.separatorStyle = .singleLine
        categoriesQuestTable.separatorColor = .clear
        categoriesQuestTable.estimatedRowHeight = 50;
        categoriesQuestTable.register(UINib(nibName: "TrainingCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TrainingCategoryTableViewCell")
       
    }
    
    private func getListQS() {
        SVProgressHUD.show()
        let firstItem = QuestCategory.init()
        firstItem.id = -1;
        firstItem.name = "Tất cả"
        lstData = [firstItem]
        traingData.getAllQuestCategoryData { [self] qestCate, error in
            SVProgressHUD.dismiss()
            if error == nil {
                lstData.append(contentsOf: qestCate)
                categoriesQuestTable.reloadData()
            }
        }
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TrainingCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingCategoryTableViewCell", for: indexPath) as! TrainingCategoryTableViewCell

        let item = lstData[indexPath.row]
        
        cell.nameLbl.text = item.name
        cell.totalLbl.text = "Tổng số câu hỏi: chưa ước lượng"
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let item = lstData[indexPath.row]
        
        SVProgressHUD.show()
        traingData.getQuestbyCategoryId(categoryId: item.id) { questResult, error in
            //
            SVProgressHUD.dismiss()
            if error == nil {
                if questResult!.total > 0 {
                    let quests = questResult
                    let newsController = TraingViewController(nibName: "TraingViewController", bundle: nil)
                    newsController.data = quests;
                    self.navigationController?.pushViewController(newsController, animated: true)
                } else {
                    var style = ToastStyle.init();
                    style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                    self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Chưa có câu hỏi cho lĩnh vực này!", image: nil, style: style, completion: nil)
                }
                
            }
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
