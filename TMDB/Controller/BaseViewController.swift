//
//  BaseViewController.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setBackButtonTitle(to titleText: String){
        let backItem = UIBarButtonItem()
        backItem.title = titleText
        navigationItem.backBarButtonItem = backItem
    }
    
}


