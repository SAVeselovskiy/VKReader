//
//  VSPageControlHelper.swift
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import Foundation

class VSPageControlHelper: NSObject, VSTourScrollViewDelegate {
    
    let pageControl: TAPageControl
    
    init(pageControl: TAPageControl, pageScrollView: VSTourScrollView) {
        self.pageControl = pageControl
        super.init()
        pageScrollView.pageDelegate = self
    }
    
    func didMoveToView(toView: UIView, toIndex: Int, fromView: UIView, fromIndex: Int) {
        self.pageControl.currentPage = toIndex
    }
    
    func didSetView(toView: UIView, toIndex: Int, fromView: UIView, fromIndex: Int) {
        
    }
    
    func tourViewDidScroll(offsetX: CGFloat) {
        
    }
    
    
}
