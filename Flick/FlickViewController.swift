//
//  FlickViewController.swift
//  Flick
//
//  Created by Takaaki on 2015/08/01.
//  Copyright (c) 2015年 takaaki. All rights reserved.
//

//
//  ViewController.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 4/27/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import performSelector_swift
import UIColor_FlatColors
import Cartography
import ReactiveUI
import CoreLocation
import Photos

class FlickViewController: UIViewController,CLLocationManagerDelegate {
    
    var swipeableView: ZLSwipeableView!
    
    // アルバム.
    var photoAssets = [PHAsset]()
    
    var myLocationManager:CLLocationManager!
    
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var colorIndex = 0
    var loadCardsFromXib = false
    
    var reloadBarButtonItem = UIBarButtonItem(title: "Reload", style: .Plain) { item in }
    var catchBarButtonItem = UIBarButtonItem(title: "Catch", style: .Plain) { item in }
    var albumBarButtonItem = UIBarButtonItem(title: "Album", style: .Plain) { item in }
    var leftBarButtonItem = UIBarButtonItem(title: "←", style: .Plain) { item in }
    var upBarButtonItem = UIBarButtonItem(title: "↑", style: .Plain) { item in }
    var rightBarButtonItem = UIBarButtonItem(title: "→", style: .Plain) { item in }
    var downBarButtonItem = UIBarButtonItem(title: "↓", style: .Plain) { item in }
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.loadViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //位置情報取得
        self.getGeo()
        
        navigationController?.setToolbarHidden(false, animated: false)
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        
        reloadBarButtonItem.addAction() { item in
            let alertController = UIAlertController(title: nil, message: "Load Cards:", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let ProgrammaticallyAction = UIAlertAction(title: "Programmatically", style: .Default) { (action) in
                self.loadCardsFromXib = false
                self.colorIndex = 0
                self.swipeableView.discardViews()
                self.swipeableView.loadViews()
            }
            alertController.addAction(ProgrammaticallyAction)
            
            let XibAction = UIAlertAction(title: "From Xib", style: .Default) { (action) in
                self.loadCardsFromXib = true
                self.colorIndex = 0
                self.swipeableView.discardViews()
                self.swipeableView.loadViews()
            }
            alertController.addAction(XibAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        catchBarButtonItem.addAction() { item in
            if(self.appDelegate._lat != nil){
                println("getCard")
                self.getCard()
            }else{
                println("getGeo")
                self.getGeo()
            }
        }
        
        albumBarButtonItem.addAction() { item in
            //アルバム取得
//            self.getAlbum()
        }
        

        leftBarButtonItem.addAction() { item in
            self.swipeableView.swipeTopView(inDirection: .Left)
        }
        upBarButtonItem.addAction() { item in
            self.swipeableView.swipeTopView(inDirection: .Up)
        }
        rightBarButtonItem.addAction() { item in
            self.swipeableView.swipeTopView(inDirection: .Right)
        }
        downBarButtonItem.addAction() { item in
            self.swipeableView.swipeTopView(inDirection: .Down)
        }
        
        var fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, action: {item in})
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, action: {item in})
        
        var items = [fixedSpace, reloadBarButtonItem, flexibleSpace ,catchBarButtonItem , flexibleSpace ,albumBarButtonItem ,flexibleSpace, leftBarButtonItem, flexibleSpace, upBarButtonItem, flexibleSpace, rightBarButtonItem, flexibleSpace, downBarButtonItem, fixedSpace]
        toolbarItems = items
        
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        swipeableView.didStart = {view, location in
            println("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            println("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            println("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            println("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            println("Did cancel swiping view")
        }
        
        swipeableView.nextView = {
            if self.colorIndex < self.colors.count {
                var cardView = CardView(frame: self.swipeableView.bounds)
                cardView.backgroundColor = self.colorForName(self.colors[self.colorIndex])
                self.colorIndex++
                
                if self.loadCardsFromXib {
                    var contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! UIView
                    contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
                    contentView.backgroundColor = cardView.backgroundColor
                    cardView.addSubview(contentView)
                    
                    // This is important:
                    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
                    /*// Alternative:
                    let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
                    let views = ["contentView": contentView, "cardView": cardView]
                    cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
                    cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
                    */
                    layout(contentView, cardView) { view1, view2 in
                        view1.left == view2.left
                        view1.top == view2.top
                        view1.width == cardView.bounds.width
                        view1.height == cardView.bounds.height
                    }
                }
                return cardView
            }
            return nil
        }
        
        layout(swipeableView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
    }
    
//    func getAlbum() {
//        photoAssets = []
//        
//        // ソート条件を指定
//        var options = PHFetchOptions()
//        options.sortDescriptors = [
//            NSSortDescriptor(key: "creationDate", ascending: false)
//        ]
//        
//        // 画像をすべて取得
//        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
//        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
//            self.photoAssets.append(asset as! PHAsset)
//        }
//        println(photoAssets)
//
//    }
//    
    
    func getCard(){
        println("getCard")
        
        // 現在日時を取得
        var date1 = NSDate()
        var cards:JSON = JSON("[{}]")
        while(true){
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            cards = self.pullCard(appDelegate._lat!,lng: appDelegate._lng!)
            
            sleep(1)
            // 現在日時を取得
            var date2 = NSDate()
            var time  = Float(date2.timeIntervalSinceDate(date1))
            println(time)
            
            if (cards.length != 0){
                break
            }
            
            if(time > Float(60)){
                break
            }
        }
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        println(JSON(cards))
        
    }

    func pullCard(lat:String,lng:String) -> JSON{
        var pullCardURL = "http://52.8.212.125:3000/pull?userid=" + appDelegate._userid! + "&lat=" + lat + "&lng=" + lng
        let pullCard = JSON(url: pullCardURL)
        println(pullCardURL)
        println(pullCard)
        return pullCard
    }
    
        
    
    func getGeo(){
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            println("didChangeAuthorizationStatus:\(status)");
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            self.myLocationManager.requestAlwaysAuthorization()
        }
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        
        // 現在位置の取得を開始.
        myLocationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        println(" CLAuthorizationStatus: \(statusStr)")
    }
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        appDelegate._lat = String(stringInterpolationSegment: manager.location.coordinate.latitude)
        appDelegate._lng = String(stringInterpolationSegment: manager.location.coordinate.longitude)
        
        println(appDelegate._lat)
        println(appDelegate._lng)
        
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    // MARK: ()
    func colorForName(name: String) -> UIColor {
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
}


extension PHPhotoLibrary {
    
    //ユーザーに許可を促す.
    class func Authorization(){
        
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status){
            case .Authorized:
                println("Authorized")
                
            case .Denied:
                println("Denied")
                
            case .NotDetermined:
                println("NotDetermined")
                
            case .Restricted:
                println("Restricted")
            }
            
        }
    }
}

