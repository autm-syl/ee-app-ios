//
//  TraingViewController.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import UIKit
import SwiftEntryKit
import SVProgressHUD
import AVFoundation

class TraingViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var fsView:FSPagerView?
    
    var data:QuestsData?
    open var indexHere: Int = 0;
    var currentPage: Int = 0;
    var currentChooseIs = 0;
    var currentChooseText = "";
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.perform(#selector(settingFSView), with: nil, afterDelay: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
        self.tabBarController?.tabBar.isHidden = false
    }

    @objc
    private func settingFSView(){
        fsView = FSPagerView.init(frame: self.contentView.bounds);
        fsView?.dataSource = self;
        fsView?.delegate = self;
        fsView?.register(FSQuestViewCell.self, forCellWithReuseIdentifier: "FSQuestViewCell");
        fsView?.automaticSlidingInterval = 0;
        fsView?.isScrollEnabled = true;
        fsView?.itemSize = self.contentView.bounds.size
        self.contentView.addSubview(fsView!);
        contentView.backgroundColor = .red
        
        self.progressView.layer.cornerRadius = 8;
        self.progressView.clipsToBounds = true;
        
        self.progressView.layer.sublayers![1].cornerRadius = 8
        self.progressView.subviews[1].clipsToBounds = true
        self.progressView.setProgress(0.0, animated: true);
        self.progressView.isHidden = false;
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.showBad()
    }
    @IBAction func nextBtnClicked(_ sender: Any) {
        if (currentChooseIs == 0) {
            return;
        } else if (currentChooseIs == 1) {
            self.showCorrect(textS: self.currentChooseText);
            self.correctSound()
        } else if (currentChooseIs == 2) {
            self.showUnCorrect(textS: self.currentChooseText);
            self.uncorrectSound()
        }
    }
    
    private func scrollToNext() {
        let count = data!.quests.count;
        if (fsView != nil) {
            if (currentPage == count - 1) {
                self.endSession();
                self.progressView.setProgress(1.0, animated: true);
                
                return;
            }
            
            if (currentPage + 1 >= count) {
                fsView?.scrollToItem(at: currentPage , animated: true);
                currentPage += 1;
            } else {
                fsView?.scrollToItem(at: currentPage + 1, animated: true);
                currentPage += 1;
            }
            
            let progress: Float =  Float (currentPage) / Float (count)
            self.progressView.setProgress(progress, animated: true);
        }
    }
    
    private func endSession() {
        //
        self.showDone()
    }

}
extension TraingViewController:FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return (data!.quests.count);
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSQuestViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSQuestViewCell", at: index);
        cell.clean()
        
        let quest = data!.quests[index]
        cell.option1Lbl.text = quest.Option1.replacingOccurrences(of: "\\n", with: "\n")
        cell.option2Lbl.text = quest.Option2.replacingOccurrences(of: "\\n", with: "\n")
        cell.option3Lbl.text = quest.Option3.replacingOccurrences(of: "\\n", with: "\n")
        cell.option4Lbl.text = quest.Option4.replacingOccurrences(of: "\\n", with: "\n")
        cell.AseBtn.setTitle("", for: .normal)
        cell.BseBtn.setTitle("", for: .normal)
        cell.CseBtn.setTitle("", for: .normal)
        cell.DseBtn.setTitle("", for: .normal)
        cell.indexQuest = index;
        cell.delegate = self;
        cell.setContentWeb(content: quest.Content.replacingOccurrences(of: "\\n", with: "\n"))
        
        return cell;
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {

    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true);
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSQuestViewCell, forItemAt index: Int){

    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSQuestViewCell, forItemAt index: Int) {

    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageNumct?.currentPage = targetIndex;
//        pageNumct?.updateDots();
    }
}
extension TraingViewController: FSQuestViewCellDelegate{
    func selectedBtn(selected: String, index: Int) {
        let quest = data!.quests[index]
        
        self.nextBtn.isSelected = true;
        
        if (selected == quest.Correct) {
            self.currentChooseIs = 1;
        } else {
            self.currentChooseIs = 2;
            // add vao cuoi
            data!.quests.append(quest);
        }
        currentChooseText = quest.Correct;
//        quest.aSe
        switch quest.Correct {
        case "option1":
            currentChooseText = quest.Option1;
            break;
        case "option2":
            currentChooseText = quest.Option2;
            break;
        case "option3":
            currentChooseText = quest.Option3;
            break;
        case "option4":
            currentChooseText = quest.Option4;
            break;
        default:
            break;
        }
        
        
    }
    
    func cleanSelect(index: Int) {
//        list_choosed = list_choosed.filter { $0 != index }
//        pageNumct?.list_choose = list_choosed;
//        pageNumct?.updateDots();
//        self.quest_selected[index] = ""
        self.nextBtn.isSelected = false;
    }
}


extension TraingViewController {
    private func showBad(){
        let attributes = self.closeAttributes;
         
         let title = EKProperty.LabelContent(
             text: "🐖",
             style: .init(
                 font: MainFont.regular.with(size: 15),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let text =
         """
         Thoát ngay?.
         """
         let description = EKProperty.LabelContent(
             text: text,
             style: .init(
                 font: MainFont.regular.with(size: 13),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let image = EKProperty.ImageContent(
             imageName: "giveupIcon",
             displayMode: EKAttributes.DisplayMode.light,
             size: CGSize(width: 40, height: 40),
             contentMode: .scaleAspectFit
         )
         let simpleMessage = EKSimpleMessage(
             image: image,
             title: title,
             description: description
         )
         let buttonFont = MainFont.regular.with(size: 16)
         let closeButtonLabelStyle = EKProperty.LabelStyle(
             font: buttonFont,
             color: Color.Gray.a800,
             displayMode: EKAttributes.DisplayMode.light
         )
         let closeButtonLabel = EKProperty.LabelContent(
             text: "Tiếp tục",
             style: closeButtonLabelStyle
         )
         let closeButton = EKProperty.ButtonContent(
             label: closeButtonLabel,
             backgroundColor: .clear,
             highlightedBackgroundColor: Color.Gray.a800.with(alpha: 0.05),
             displayMode: EKAttributes.DisplayMode.light) {
                SwiftEntryKit.dismiss();
         }
        
         let okButtonLabelStyle = EKProperty.LabelStyle(
             font: buttonFont,
             color: Color.Teal.a600,
             displayMode: EKAttributes.DisplayMode.light
         )
         let okButtonLabel = EKProperty.LabelContent(
             text: "OK",
             style: okButtonLabelStyle
         )
         let okButton = EKProperty.ButtonContent(
             label: okButtonLabel,
             backgroundColor: .clear,
             highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
             displayMode: EKAttributes.DisplayMode.light) {
                 //
                 SwiftEntryKit.dismiss()
                self.navigationController?.popViewController(animated: true);
         }
         // Generate the content
         let buttonsBarContent = EKProperty.ButtonBarContent(
             with: okButton, closeButton,
             separatorColor: Color.Gray.light,
             displayMode: EKAttributes.DisplayMode.light,
             expandAnimatedly: true
         )
         let alertMessage = EKAlertMessage(
             simpleMessage: simpleMessage,
             buttonBarContent: buttonsBarContent
         )
         let contentView = EKAlertMessageView(with: alertMessage)
         SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private func showDone(){
        let attributes = self.doneAttributes;
         
         let title = EKProperty.LabelContent(
             text: "🌈",
             style: .init(
                 font: MainFont.regular.with(size: 15),
                 color: .white,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let text =
         """
         Chúc mừng bạn đã hoàn thành!.
         """
         let description = EKProperty.LabelContent(
             text: text,
             style: .init(
                 font: MainFont.regular.with(size: 13),
                 color: .white,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let image = EKProperty.ImageContent(
             imageName: "finishIcon",
             displayMode: EKAttributes.DisplayMode.light,
             size: CGSize(width: 40, height: 40),
             contentMode: .scaleAspectFit
         )
         let simpleMessage = EKSimpleMessage(
             image: image,
             title: title,
             description: description
         )
         let buttonFont = MainFont.regular.with(size: 16)
         let okButtonLabelStyle = EKProperty.LabelStyle(
             font: buttonFont,
             color: .white,
             displayMode: EKAttributes.DisplayMode.light
         )
         let okButtonLabel = EKProperty.LabelContent(
             text: "DONE",
             style: okButtonLabelStyle
         )
         let okButton = EKProperty.ButtonContent(
             label: okButtonLabel,
             backgroundColor: .clear,
             highlightedBackgroundColor: Color.LightBlue.a700.with(alpha: 0.05),
             displayMode: EKAttributes.DisplayMode.light) {
                 //
                SwiftEntryKit.dismiss()
                self.navigationController?.popViewController(animated: true);
         }
         // Generate the content
         let buttonsBarContent = EKProperty.ButtonBarContent(
             with: okButton,
             separatorColor: Color.Gray.light,
             displayMode: EKAttributes.DisplayMode.light,
             expandAnimatedly: true
         )
         let alertMessage = EKAlertMessage(
             simpleMessage: simpleMessage,
             buttonBarContent: buttonsBarContent
         )
         let contentView = EKAlertMessageView(with: alertMessage)
         SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private func showCorrect(textS: String){
        let attributes = self.correctAttributes;
         
         let title = EKProperty.LabelContent(
             text: "🦋",
             style: .init(
                 font: MainFont.regular.with(size: 15),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let text =
         """
            Chính xác:
         \(textS)
         """
         let description = EKProperty.LabelContent(
             text: text,
             style: .init(
                 font: MainFont.regular.with(size: 13),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.light
             )
         )
         let image = EKProperty.ImageContent(
             imageName: "giveupIcon",
             displayMode: EKAttributes.DisplayMode.light,
             size: CGSize(width: 40, height: 40),
             contentMode: .scaleAspectFit
         )
         let simpleMessage = EKSimpleMessage(
             image: image,
             title: title,
             description: description
         )
         let buttonFont = MainFont.regular.with(size: 16)
        
         let okButtonLabelStyle = EKProperty.LabelStyle(
             font: buttonFont,
             color: Color.Teal.a600,
             displayMode: EKAttributes.DisplayMode.light
         )
         let okButtonLabel = EKProperty.LabelContent(
             text: "Câu tiếp theo",
             style: okButtonLabelStyle
         )
         let okButton = EKProperty.ButtonContent(
             label: okButtonLabel,
             backgroundColor: .clear,
             highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
             displayMode: EKAttributes.DisplayMode.light) {
                 //
                 SwiftEntryKit.dismiss()
                self.scrollToNext();
                self.currentChooseIs = 0;
                self.currentChooseText = "";
                self.nextBtn.isSelected = false;
         }
         // Generate the content
         let buttonsBarContent = EKProperty.ButtonBarContent(
             with: okButton,
             separatorColor: Color.Gray.light,
             displayMode: EKAttributes.DisplayMode.light,
             expandAnimatedly: true
         )
         let alertMessage = EKAlertMessage(
             simpleMessage: simpleMessage,
             buttonBarContent: buttonsBarContent
         )
         let contentView = EKAlertMessageView(with: alertMessage)
         SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private func showUnCorrect(textS: String){
        let attributes = self.unCorrectAttributes;
         
         let title = EKProperty.LabelContent(
             text: "🐖",
             style: .init(
                 font: MainFont.regular.with(size: 15),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.dark
             )
         )
         let text =
         """
            Đáp án đúng là:
         \(textS)
         """
         let description = EKProperty.LabelContent(
             text: text,
             style: .init(
                 font: MainFont.regular.with(size: 13),
                 color: .black,
                 alignment: .center,
                 displayMode: EKAttributes.DisplayMode.dark
             )
         )
         let image = EKProperty.ImageContent(
             imageName: "giveupIcon",
             displayMode: EKAttributes.DisplayMode.dark,
             size: CGSize(width: 40, height: 40),
             contentMode: .scaleAspectFit
         )
         let simpleMessage = EKSimpleMessage(
             image: image,
             title: title,
             description: description
         )
         let buttonFont = MainFont.regular.with(size: 16)
        
         let okButtonLabelStyle = EKProperty.LabelStyle(
             font: buttonFont,
             color: Color.Teal.a600,
             displayMode: EKAttributes.DisplayMode.dark
         )
         let okButtonLabel = EKProperty.LabelContent(
             text: "Câu tiếp theo",
             style: okButtonLabelStyle
         )
         let okButton = EKProperty.ButtonContent(
             label: okButtonLabel,
             backgroundColor: .clear,
             highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
             displayMode: EKAttributes.DisplayMode.dark) {
                 //
                 SwiftEntryKit.dismiss()
                self.fsView?.reloadData();
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scrollToNext();
                }
                self.currentChooseIs = 0;
                self.currentChooseText = "";
                self.nextBtn.isSelected = false;
         }
         // Generate the content
         let buttonsBarContent = EKProperty.ButtonBarContent(
             with: okButton,
             separatorColor: Color.Gray.light,
             displayMode: EKAttributes.DisplayMode.dark,
             expandAnimatedly: true
         )
         let alertMessage = EKAlertMessage(
             simpleMessage: simpleMessage,
             buttonBarContent: buttonsBarContent
         )
         let contentView = EKAlertMessageView(with: alertMessage)
         SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    
    // atribute
    
    
    // Cumputed for the sake of reusability
       var correctAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat;
        attributes = .bottomFloat;
        attributes.displayMode = .light;
        attributes.hapticFeedbackType = .success;
        attributes.statusBar = .dark;
        attributes.displayDuration = .infinity;
        attributes.screenInteraction = .absorbTouches;
        attributes.entryInteraction = .absorbTouches;
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        );
        attributes.screenBackground = .color(color: .dimmedLightBackground);
        attributes.entryBackground = .color(color: .white);
          attributes.entranceAnimation = .init(
              translate: .init(
                  duration: 0.1,
                  spring: .init(damping: 1, initialVelocity: 0)
              ),
              scale: .init(
                  from: 0.6,
                  to: 1,
                  duration: 0.1
              ),
              fade: .init(
                  from: 0.8,
                  to: 1,
                  duration: 0.1
              )
          )
          attributes.exitAnimation = .init(
              scale: .init(
                  from: 1,
                  to: 0.4,
                  duration: 0.1
              ),
              fade: .init(
                  from: 1,
                  to: 0,
                  duration: 0.1
              )
          )
        attributes.border = .value(color: .black, width: 0.5);
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        return attributes
    }
    
    var closeAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat;
        attributes = .bottomFloat;
        attributes.displayMode = .light;
        attributes.hapticFeedbackType = .success;
        attributes.statusBar = .dark;
        attributes.displayDuration = .infinity;
        attributes.screenInteraction = .dismiss;
        attributes.entryInteraction = .absorbTouches;
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        );
        attributes.screenBackground = .color(color: .dimmedLightBackground);
        attributes.entryBackground = .color(color: .white);
          attributes.entranceAnimation = .init(
              translate: .init(
                  duration: 0.4,
                  spring: .init(damping: 1, initialVelocity: 0)
              ),
              scale: .init(
                  from: 0.6,
                  to: 1,
                  duration: 0.4
              ),
              fade: .init(
                  from: 0.8,
                  to: 1,
                  duration: 0.2
              )
          )
          attributes.exitAnimation = .init(
              scale: .init(
                  from: 1,
                  to: 0.4,
                  duration: 0.3
              ),
              fade: .init(
                  from: 1,
                  to: 0,
                  duration: 0.2
              )
          )
        attributes.border = .value(color: .black, width: 0.5);
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        return attributes
    }
    
    var unCorrectAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat;
        attributes = .bottomFloat;
        attributes.displayMode = .light;
        attributes.hapticFeedbackType = .success;
        attributes.statusBar = .dark;
        attributes.displayDuration = .infinity;
        attributes.screenInteraction = .absorbTouches;
        attributes.entryInteraction = .absorbTouches;
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        );
        attributes.screenBackground = .color(color: .dimmedLightBackground);
        attributes.entryBackground = .color(color: .init(red: 247, green: 123, blue: 119));
          attributes.entranceAnimation = .init(
              translate: .init(
                  duration: 0.1,
                  spring: .init(damping: 1, initialVelocity: 0)
              ),
              scale: .init(
                  from: 0.6,
                  to: 1,
                  duration: 0.1
              ),
              fade: .init(
                  from: 0.8,
                  to: 1,
                  duration: 0.1
              )
          )
          attributes.exitAnimation = .init(
              scale: .init(
                  from: 1,
                  to: 0.4,
                  duration: 0.1
              ),
              fade: .init(
                  from: 1,
                  to: 0,
                  duration: 0.1
              )
          )
        attributes.border = .value(color: .black, width: 0.5);
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        return attributes
    }
    
    var doneAttributes: EKAttributes {
        var attributes = EKAttributes.centerFloat;
        attributes = .centerFloat;
        attributes.displayMode = .light;
        attributes.hapticFeedbackType = .success;
        attributes.statusBar = .light;
        attributes.displayDuration = .infinity;
        attributes.screenInteraction = .absorbTouches;
        attributes.entryInteraction = .absorbTouches;
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        );
        attributes.screenBackground = .color(color: .dimmedLightBackground);
        attributes.entryBackground = .color(color: .init(red: 6, green: 145, blue: 118))
//        attributes.entryBackground = .color(color: .init(red: 4, green: 97, blue: 78).with(alpha: 0.5));
          attributes.entranceAnimation = .init(
              translate: .init(
                  duration: 0.1,
                  spring: .init(damping: 1, initialVelocity: 0)
              ),
              scale: .init(
                  from: 0.6,
                  to: 1,
                  duration: 0.1
              ),
              fade: .init(
                  from: 0.8,
                  to: 1,
                  duration: 0.1
              )
          )
          attributes.exitAnimation = .init(
              scale: .init(
                  from: 1,
                  to: 0.4,
                  duration: 0.1
              ),
              fade: .init(
                  from: 1,
                  to: 0,
                  duration: 0.1
              )
          )
        attributes.border = .value(color: .orange, width: 0.5);
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        return attributes
    }
}


extension TraingViewController{
    func correctSound() {
        guard let url = Bundle.main.url(forResource: "correct", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func uncorrectSound() {
        guard let url = Bundle.main.url(forResource: "wrong", withExtension: "aiff") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func doneSound(){
        
    }
}
