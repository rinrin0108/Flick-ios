//
//  CatchFlickViewController.swift
//  Flick
//
//  Created by 林田 敦 on 2015/08/02.
//  Copyright (c) 2015年 takaaki. All rights reserved.
//

import UIKit

class CatchFlickViewController: UIViewController {
    var imageView: UIImageView!
    var clickFilterView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        /*
        clickFilterView = UICollectionView(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
        clickFilterView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        clickFilterView.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target:self, action:"onCatchCard:")
        clickFilterView.addGestureRecognizer(gesture)
        self.view.addSubview(clickFilterView)
          */
        
        let cardImage = UIImage(named : "Item1")
        imageView = UIImageView(frame: CGRectMake(0,0,cardImage!.size.width/2,cardImage!.size.height/2))
        imageView.image = cardImage
        imageView.layer.position = CGPoint(x: self.view.frame.width/2, y: -imageView.frame.height)
        //imageView.userInteractionEnabled = true
        //let gesture = UITapGestureRecognizer(target:self, action:"onCatchCard:")
        //imageView.addGestureRecognizer(gesture)
        
        self.view.addSubview(imageView)
        //clickFilterView.addSubview(imageView)
        
        //UIViewAnimationOptions options = UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction;
        
        /* 落ちるアニメーション */
        // アニメーションするプロパティを指定し、オブジェクト作成
        let moveToDown = CABasicAnimation(keyPath: "position.y")
        // アニメーションの初期値
        moveToDown.fromValue = -imageView.frame.height/2
        // アニメーションの終了時の値
        moveToDown.toValue = self.view.frame.height + imageView.frame.height/2
        // アニメーションの時間
        moveToDown.duration = 1.5
        moveToDown.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.imageView.layer.addAnimation(moveToDown, forKey: "moveToDown")
        
        /* 回転するアニメーション */
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = M_PI / 180 * 360
        rotation.duration = 5.0
        rotation.repeatCount = Float.infinity
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.imageView.layer.addAnimation(rotation, forKey: "rotation")
        
    }
    
    
    // Cardキャッチ時にアニメーションを停止する
    func onCatchCard(recognizer: UIGestureRecognizer) {
        println("catched!")
        self.imageView.layer.removeAnimationForKey("moveToDown")
        self.imageView.layer.removeAnimationForKey("rotation")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("\(__FUNCTION__) is called!!")
        
        // タッチをやり始めた座標を取得
        let touch: UITouch = touches.first as! UITouch
        var startPoint = touch.locationInView(self.view)
        
        println("startPoint =\(startPoint)")
        println("cardPoint =\(imageView.layer.presentationLayer().frame.midX),\(imageView.layer.presentationLayer().frame.midY)")
        
        if imageView.layer.presentationLayer().frame.minX < startPoint.x
        && imageView.layer.presentationLayer().frame.maxX > startPoint.x
        && imageView.layer.presentationLayer().frame.minY < startPoint.y
        && imageView.layer.presentationLayer().frame.maxY > startPoint.y {
            println("catched!")
            self.imageView.layer.position = CGPoint(x: imageView.layer.presentationLayer().frame.midX , y: imageView.layer.presentationLayer().frame.midY)
            self.imageView.layer.removeAnimationForKey("moveToDown")
            self.imageView.layer.removeAnimationForKey("rotation")
        }
    }
    
}