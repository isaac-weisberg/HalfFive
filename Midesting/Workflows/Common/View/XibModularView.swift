//
//  XibModularView.swift
//  Pobjects
//
//  Created by Isaac Weisberg on 4/5/18.
//  Copyright © 2018 Isaac Weisberg. All rights reserved.
//

import UIKit

protocol XibRenewer: class {
    var xibView: UIView? { get set }
    
    func renewXib()
}

extension XibRenewer where Self: UIView {
    func renewXib() {
        if let xibView = xibView {
            xibView.removeFromSuperview()
        }
        if let view = UINib(nibName: "\(self.classForCoder)", bundle: .main).instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
            xibView = view
        }
    }
}

class XibModularView: UIView, XibRenewer {
    var xibView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        renewXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renewXib()
    }
}
