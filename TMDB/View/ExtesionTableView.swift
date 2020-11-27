//
//  ExtesionTableView.swift
//  TMDB
//
//  Created by Denny Arfansyah on 27/11/20.
//

import UIKit

extension UITableView {

    func setEmptyView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
            emptyView.backgroundColor = .clear
        
        let message: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Menlo-Bold", size: 18)
            label.text = K.noRecordsFounds
            return label
        }()
        
        emptyView.addSubview(message)
        
        message.translatesAutoresizingMaskIntoConstraints = false
        message.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func setTableViewBackground(count: Int) {
        if count == 0 {
            setEmptyView()
        } else {
            backgroundView = nil
            separatorStyle = .singleLine
        }
    }
    
}
