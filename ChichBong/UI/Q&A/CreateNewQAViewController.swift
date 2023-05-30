//
//  CreateNewQAViewController.swift
//  ChichBong
//
//  Created by autm on 24/12/2021.
//

import UIKit
import Toast_Swift

protocol CreateNewQAViewControllerDelegate: AnyObject {
    func createNewQASuccess()
}

class CreateNewQAViewController: BaseViewController {
    @IBOutlet weak var nameQAField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var createBtn: UIButton!
    
    var _isActiveBtn:Bool = false
    var isActiveBtn:Bool {
        get {
            return _isActiveBtn;
        }
        set (value) {
            if value {
                // set button color
                createBtn.backgroundColor = #colorLiteral(red: 0.75939399, green: 0.6963812709, blue: 0.5035656691, alpha: 1)
            } else {
                // set button color
                createBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            _isActiveBtn = value
        }
    }
    
    weak var delegate:CreateNewQAViewControllerDelegate?
    
    var prevText: String = ""
    let editorView = UITextView()
//    let toolbar = RichEditorToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        additionalSafeAreaInsets = .init(top: 6, left: 12, bottom: 0, right: 12)
        editorView.translatesAutoresizingMaskIntoConstraints = false
//        editorView.delegate = self
        editorView.isEditable = true
        editorView.delegate = self;
        contentView.addSubview(editorView)
        let sa = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            editorView.topAnchor.constraint(equalTo: sa.topAnchor),
            editorView.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            editorView.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            editorView.bottomAnchor.constraint(equalTo: sa.bottomAnchor)
        ])
        nameQAField.delegate = self;
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createBtnClicked(_ sender: Any) {
        if _isActiveBtn {
            //
            // create new quest
            let name = nameQAField.text
            let content = editorView.text
            
            if (name == nil) || name == "" {
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Bạn chưa nhập câu hỏi", image: nil, style: style, completion: nil)
                return;
            }
            if (content == nil) || content == "" {
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Bạn chưa mô tả nội dung!", image: nil, style: style, completion: nil)
                return;
            }
            
            MonConnection.requestCustom(APIRouter.createNewQA(name: name!, content: content!)) { [self] result, error in
                //
                if error != nil {
                    //
                    var style = ToastStyle.init();
                    style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                    self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Tạo câu hỏi lỗi\nHãy thử lại sau!", image: nil, style: style, completion: nil)
                    
                    if error?.mErrorCode == 401 {
                        self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                    }
                    
                    return;
                }
                
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.00246796431, green: 0.6601009965, blue: 0.6580886245, alpha: 1)
                self.view.makeToast("✅", duration: 4.0, position: .bottom, title: "Tạo câu hỏi thành công", image: nil, style: style, completion: nil)
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.5) {
                    delegate?.createNewQASuccess()
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
}

extension CreateNewQAViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" && self.editorView.text != "" {
            self.isActiveBtn = true
        } else {
            self.isActiveBtn = false
        }
    }
}
extension CreateNewQAViewController:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" && self.nameQAField.text != "" {
            self.isActiveBtn = true
        } else {
            self.isActiveBtn = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //
        if textView.text != "" {
            self.isActiveBtn = true
        } else {
            self.isActiveBtn = false
        }
    }
}
