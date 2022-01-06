//
//  RootIntroViewController.swift
//  ChichBong
//
//  Created by Sylvanas on 4/19/21.
//

import UIKit

class RootIntroViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var tutorialPageViewController: IntroViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        
        pageControl.isHidden = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? IntroViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    @IBAction func didTapNextButton(_ sender: Any) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    @objc func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}


extension RootIntroViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: IntroViewController,
        didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: IntroViewController,
        didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
