//
//  CreateCaseStudyViewController.swift
//  ChichBong
//
//  Created by autm on 24/12/2021.
//

import UIKit
import Toast_Swift
import SVProgressHUD
import MediaPlayer

protocol CreateCaseStudyViewControllerDelegate:AnyObject {
    func createCastudySuccess()
}

class CreateCaseStudyViewController: BaseViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nameQAField: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    
    
    @IBOutlet weak var doituongField: UITextView!
    @IBOutlet weak var diadiemField: UITextView!
    @IBOutlet weak var noidungdienbienField: UITextView!
    @IBOutlet weak var motadinhkemView: UIView!
    @IBOutlet weak var phantichsoboField: UITextView!
    @IBOutlet weak var phantichchitietField: UITextView!
    @IBOutlet weak var dexuatgiaiphapField: UITextView!
    @IBOutlet weak var listImageAttchireCollection: UICollectionView!
    
    var imagePicker: UIImagePickerController!
    
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
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    var lstArchire:[String] = [""]
    
    weak var delegate:CreateCaseStudyViewControllerDelegate?
    
    var prevText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isActiveBtn = true;
        setup()
    }
    
    func setup() {
        let layoutmain: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutmain.scrollDirection = .horizontal
        listImageAttchireCollection.collectionViewLayout = layoutmain
        listImageAttchireCollection.delegate = self
        listImageAttchireCollection.dataSource = self
        listImageAttchireCollection.register(UINib(nibName: "ImagePickedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagePickedCollectionViewCell")
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createBtnClicked(_ sender: Any) {
        if _isActiveBtn {
            //
            // create new quest
            let doituong = self.doituongField.text ?? ""
            let diadiem = self.diadiemField.text ?? ""
            let noidung = self.noidungdienbienField.text ?? ""
            var attachment = ""
            
            if lstArchire.count > 1 {
                for imgurl in lstArchire {
                    if imgurl != "" {
                        if imgurl.hasSuffix("png") {
                            attachment += "<img src='\(imgurl)' /> <br/>"
                        } else if imgurl.hasSuffix("MOV") {
                            attachment += "<iframe class='ql-video' frameborder='0' allowfullscreen='true' src='\(imgurl)'></iframe> <br/>"
                        }
                    }
                }
            }

            let sobo = self.phantichsoboField.text ?? ""
            let chitiet = self.phantichchitietField.text ?? ""
            let giaiphap = self.dexuatgiaiphapField.text ?? ""
            
            let content:String = """
                <p><strong style='color: rgb(0, 0, 0);'>- Đối tượng bị sự cố: </strong>\(doituong)</p><p><br></p><p><strong>- Địa điểm sự cố:</strong>\(diadiem)</p><p><br></p><p><strong>- Nội dung/Diễn biến sự cố:</strong>\(noidung)</p><p><br></p><p><strong>- Các hình ảnh đính kèm:</strong></p>\(attachment)<p><br></p><p><strong>- Phân tích sơ bộ nguyên nhân sự cố:</strong>\(sobo)</p><p><br></p><p><strong style='color: rgb(0, 0, 0);'>- Phân tích chi tiết nguyên nhân sự cố:</strong>\(chitiet)</p><p><br></p><p><strong style='color: rgb(0, 0, 0);'>- Đề xuất giải pháp ngăn ngừa sự cố:</strong>\(giaiphap)</p>
                """
            

            let name = nameQAField.text
            
            if (name == nil) || name == "" {
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Bạn chưa nhập tiêu đề", image: nil, style: style, completion: nil)
                return;
            }
            if doituong == "" && diadiem == "" && noidung == "" && sobo == "" && chitiet == "" && giaiphap == "" {
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Bạn chưa mô tả nội dung!", image: nil, style: style, completion: nil)
                return;
            }
            
            MonConnection.requestCustom(APIRouter.createCaseStudy(name: name!, content: content)) { [self] result, error in
                //
                if error != nil {
                    //
                    
                    var style = ToastStyle.init();
                    style.messageColor = #colorLiteral(red: 0.7412630916, green: 0.6745089293, blue: 0.4580433369, alpha: 1)
                    self.view.makeToast("‼️", duration: 4.0, position: .bottom, title: "Tạo mới lỗi\nHãy thử lại sau!", image: nil, style: style, completion: nil)
                    
                    if error?.mErrorCode == 401 {
                        self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                    }
                    
                    return;
                }
                
                var style = ToastStyle.init();
                style.messageColor = #colorLiteral(red: 0.00246796431, green: 0.6601009965, blue: 0.6580886245, alpha: 1)
                self.view.makeToast("✅", duration: 4.0, position: .bottom, title: "Tạo mới thành công", image: nil, style: style, completion: nil)
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.5) {
                    self.navigationController?.popViewController(animated: true)
                    delegate?.createCastudySuccess()
                }
            }
        }
    }
    
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.image", "public.movie", "public.audio"]
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            imagePickerController.videoQuality = UIImagePickerController.QualityType(rawValue: 100)!
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func getAudio() {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = self.view
        controller.delegate = self
        self.present(controller, animated: true)
    }
}


extension CreateCaseStudyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return lstArchire.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickedCollectionViewCell", for: indexPath) as! ImagePickedCollectionViewCell
        
        let item = lstArchire[indexPath.row]
        
        cell.setImagePreview(imageUrl: item)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.size.height - minimumInteritemSpacing).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}


extension CreateCaseStudyViewController:ImagePickedCollectionViewCellDelegate {
    func wantToPickImage(thisCell: UICollectionViewCell) {
//        let video_audio = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        video_audio.addAction(UIAlertAction(title: "Video + Image", style: .default, handler: {(action: UIAlertAction) in
//
//            video_audio.dismiss(animated: true, completion: nil)
//            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action: UIAlertAction) in
//                self.getImage(fromSourceType: .camera)
//            }))
//            alert.addAction(UIAlertAction(title: "photo allbum", style: .default, handler: {(action: UIAlertAction) in
//                self.getImage(fromSourceType: .photoLibrary)
//            }))
//            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }))
//        video_audio.addAction(UIAlertAction(title: "audio", style: .default, handler: {(action: UIAlertAction) in
//            video_audio.dismiss(animated: true, completion: nil)
//            self.getAudio()
//        }))
//
//        video_audio.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
//        self.present(video_audio, animated: true, completion: nil)
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "photo allbum", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = thisCell as UIView
                popoverPresentationController.sourceRect = thisCell.bounds
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateCaseStudyViewController: UIImagePickerControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            let imagePick = info[.originalImage] as? UIImage
            let image = imagePick?.fixOrientation();
   
            uploadImage(image: image!)
        } else if let videoURL = info[.mediaURL] as? URL{
           //
            print("pick vao video:", videoURL)
            uploadVideo(videoURL: videoURL);
        } else {
            showError(mess: "File lỗi")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image : UIImage) {
        SVProgressHUD.show()
        MonConnection.UploadImageFile(fileData: image.pngData()!) { [self] result, error in
            //
            SVProgressHUD.dismiss()
            if error != nil {
              // loi
              showError(mess: "Up ảnh thất bại")
                
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
                
              return;
            }
            let uploadResult = UploadImageResult.init(JSON: result!)
            if uploadResult?.Data != "" {
                showNotify(mess: "Up ảnh thành công")
                lstArchire.insert(uploadResult?.Data ?? "", at: 0)
                self.listImageAttchireCollection.reloadData()
            } else {
                showError(mess: "Có lỗi xảy ra")
            }
        }
        
        
    }
    func uploadVideo(videoURL : URL) {
        SVProgressHUD.show()
        MonConnection.UploadVideoFile(fileURL: videoURL) { [self] result, error in
            //
            SVProgressHUD.dismiss()
            if error != nil {
              // loi
              showError(mess: "Up video thất bại")
                
                if error?.mErrorCode == 401 {
                    self.showError(mess: "Lỗi xác thực tài khoản!\nCó ai đó đã đăng nhập trên thiết bị khác.")
                }
                
              return;
            }
            let uploadResult = UploadImageResult.init(JSON: result!)
            if uploadResult?.Data != "" {
                showNotify(mess: "Up video thành công")
                lstArchire.insert(uploadResult?.Data ?? "", at: 0)
                self.listImageAttchireCollection.reloadData()
            } else {
                showError(mess: "Có lỗi xảy ra")
            }
        }
        
        
    }
}


extension CreateCaseStudyViewController:MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Get the system music player.
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        musicPlayer.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
        // Begin playback.
        musicPlayer.play()
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
}
