//
//  SwiftLoading.swift
//  HopOn
//
//  Created by Intern on 25/10/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class SwiftLoading {
    
    var loadingView = UIView()
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showLoading() {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(self.loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/3, height: win.frame.width/3))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.loadingView.center
        
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = self.loadingView.center
        
        
        self.loadingView.addSubview(container)
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
    func hideLoading(){
        UIView.animate(withDuration: 0.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.container.alpha = 0.0
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
            }, completion: { finished in
                self.activityIndicator.removeFromSuperview()
                self.container.removeFromSuperview()
                self.loadingView.removeFromSuperview()
                let win:UIWindow = UIApplication.shared.delegate!.window!!
                let removeView  = win.viewWithTag(1)
                removeView?.removeFromSuperview()
        })
    }
}
