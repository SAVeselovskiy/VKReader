//
//  File.swift
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import UIKit

protocol VSTourScrollViewDelegate {
    func didMoveToView(toView: UIView, toIndex: Int, fromView: UIView, fromIndex: Int)
    func didSetView(toView: UIView, toIndex: Int, fromView: UIView, fromIndex: Int)
    func tourViewDidScroll(offsetX: CGFloat)
}

class VSTourScrollView: UIScrollView, UIScrollViewDelegate {
    
    var views: [UIView] = []
    var pageDelegate: VSTourScrollViewDelegate?
    var prevIndex: Int = 0
    var rotateSize: CGSize?
    var currentIndex: Int = 0{
        didSet{
            print("Current: \(currentIndex)")
            prevIndex = oldValue
            //вызвать метод делегата
            if oldValue < views.count && currentIndex < views.count && currentIndex >= 0{
                self.pageDelegate?.didMoveToView(toView: views[currentIndex],  toIndex: currentIndex, fromView: views[oldValue], fromIndex: oldValue)
            }
            //            print(currentIndex)
        }
    }
    var currentLastExactIndex: Int = 0
    func setViews(views:[UIView]){
        self.views = views
        var view = self.views[0]
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        //перый контроллер к левому краю
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
        //к верхней грани
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        //к нижней грани
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        //ширина
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.width))
        let constrHeight = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.height)
        constrHeight.priority = UILayoutPriorityDefaultLow
        view.addConstraint(constrHeight)
        if (views.count == 1){
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
            return
        }
        for i in 1...views.count-1 {
            let view1 = self.views[i]
            view1.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view1)
            //к верхней грани
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view1, attribute: .top, multiplier: 1.0, constant: 0.0))
            //к нижней
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view1, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            //между i и i-1
            self.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: view1, attribute: .leading, multiplier: 1.0, constant: 0.0))
            //ширина i
            view1.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.width))
            let constraint = NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.height)
            constraint.priority = UILayoutPriorityDefaultLow
            view1.addConstraint(constraint)
            
            if i == views.count-1 {
                self.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view1, attribute: .right, multiplier: 1.0, constant: 0.0))
            }
            view = view1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in views {
            for constraint in view.constraints {
                if (constraint.firstAttribute == NSLayoutAttribute.width) {
                    constraint.constant = self.frame.width
                }
            }
            for constraint in view.constraints {
                if (constraint.firstAttribute == NSLayoutAttribute.height) {
                    constraint.constant = self.frame.height
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        
    }
    func customInit(){
        self.isPagingEnabled = true
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

    }
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        customInit()
        
    }
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        self.setContentOffset(CGPoint(x: self.bounds.size.width*CGFloat(self.currentLastExactIndex), y: 0), animated: false)
    //        print("New contetntOffset after changing Size: \(self.bounds.size.width*CGFloat(self.currentLastExactIndex))")
    //    }
    //    func observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
    //    {
    //        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*self.pageIndicator.currentState, 0)];
    //
    //        [self.pageIndicator scrollIndicatorTo:self.scrollView.bounds.size.width/2*self.pageIndicator.currentState];
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.bounds.size.width == 0 {
            return
        }
        let width = Float(self.frame.width)
        if self.rotateSize != nil {
            return
        }
        let offsetX : CGFloat = scrollView.contentOffset.x
        pageDelegate?.tourViewDidScroll(offsetX: offsetX)
        var tmp: Float = 0.0
        if Float(offsetX).truncatingRemainder(dividingBy: width)  >= width/2{
            tmp = ceilf(Float(offsetX) / width)
        }
        else{
            tmp = floorf(Float(offsetX) / width)
        }
        let currIndex = Int(tmp)
        
        if currIndex != currentIndex{ //&& currIndex >= 0 && currIndex < self.viewControllers.count{
            currentIndex = (currIndex >= self.views.count ? self.views.count - 1 : currIndex)
            print(offsetX)
            print(currIndex)
        }
        if Float(offsetX).truncatingRemainder(dividingBy: width) == 0{
            tmp = floorf(Float(offsetX) / width)
            currentLastExactIndex = Int(tmp)
            print("Current exact: \(tmp)")
            self.pageDelegate?.didSetView(toView: views[Int(tmp)],  toIndex: Int(tmp), fromView: views[prevIndex], fromIndex: prevIndex)
        }
    }
    
    func scrollToLast(){
        UIView.animate(withDuration: 0.5, animations: {
            self.contentOffset = CGPoint(x: self.contentSize.width - self.frame.width, y: self.contentOffset.y)
        }) { (finished) in
            //            print("Scroll is done")
        }
    }
    
    func scrollTo(index: Int){
        if index >= views.count{
            scrollToLast()
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            let ind = CGFloat(index)
            self.contentOffset = CGPoint(x: self.frame.width * ind, y: self.contentOffset.y)
        }) { (finished) in
            //            print("Scroll is done")
        }
    }
}

