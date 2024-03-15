//
//  SelfSizedUITableIvew.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import UIKit

class SelfSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
