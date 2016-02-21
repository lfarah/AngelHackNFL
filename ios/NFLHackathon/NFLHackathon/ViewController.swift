//
//  ViewController.swift
//  NFLHackathon
//
//  Created by Lucas Farah on 2/20/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var fieldView: UIView!
  
  var quarter = 0
  var currentPlay = 0
  enum Team
  {
    case Home
    case Away
  }
  
  enum PlayerType
  {
    case Quarterback
    case Other
  }
  
  var play = 0
  var timer = NSTimer()
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //6.141666667
    //7.373358349
    
    
    parsePlay(0)
    
//    self.fieldView.backgroundColor = UIColor(patternImage: UIImage(named: "touchdown and background")!)
    
  }
  
  func parsePlay(play:Int)
  {
    if play <= 9
    {
      let sample = self.readJSON(play)
      
      var seconds = 0
      self.timer = NSTimer.runThisEvery(seconds: 0.1) {
        (timer) -> Void in
        self.parsePlayersTracking(play,seconds: seconds,team: .Home,sample: sample)
        self.parsePlayersTracking(play,seconds: seconds,team:.Away,sample: sample)
        seconds++
      }
    }
  }
  func parsePlayersTracking(play:Int,seconds:Int,team:Team,sample: Dictionary<String, AnyObject>)
  {
    var players = Array<AnyObject>()
    switch team
    {
    case .Home:
      players = sample["homeTrackingData"] as! Array<AnyObject>
      break
      
    case .Away:
      players = sample["awayTrackingData"] as! Array<AnyObject>
      
      break
    }
    
    var count = players[0]["playerTrackingData"]!!.count
    if seconds < count
    {
      for player in players
      {
        //        //Fixing player tracking sensor
        //        if player["playerTrackingData"]!!.count < count
        //        {
        //          count = player["playerTrackingData"]!!.count
        //        }
        if seconds < player["playerTrackingData"]!!.count
        {
          let x = player["playerTrackingData"]!![seconds]["x"]
          let y = player["playerTrackingData"]!![seconds]["y"]
          
          
          if seconds > 0
          {
            let xPrevious = player["playerTrackingData"]!![seconds - 1]["x"]
            let yPrevious = player["playerTrackingData"]!![seconds - 1]["y"]
            self.removeFromField(xPrevious as! Double, y: yPrevious as! Double)
          }
          
          if player["nflId"] as! Int == 71281 || player["nflId"] as! Int == 2495312
          {
            if play == currentPlay
            {
              
            }
            else
            {
              self.addToFIeld(x as! Double, y: y as! Double,team:team, playerType: .Quarterback)
              print(quarter)
              quarter++
              currentPlay++
            }
          }
          else
          {
            self.addToFIeld(x as! Double, y: y as! Double,team:team, playerType: .Other)
            
          }
        }
      }
    }
    else
    {
      if team == .Away
      {
        self.timer.invalidate()
        self.fieldView.removeSubviews()
        self.play += 1
        self.parsePlay(play + 1)
      }
    }
  }
  
  func addToFIeld(x:Double,y:Double,team:Team,playerType: PlayerType)
  {
    let view = UIView(x: x.toFloat * 6.14, y: y.toFloat * 7.37, w: 20, h: 20)
    
    switch team
    {
    case .Home:
      view.backgroundColor = UIColor.orangeColor()
      break
      
    case .Away:
      view.backgroundColor = UIColor.blueColor()
      break
    }
    
    view.makeCircular()
    
    if playerType == PlayerType.Quarterback
    {
      view.makeQuarterBack()
    }
    fieldView.addSubview(view)
  }
  
  func removeFromField(x:Double,y:Double)
  {
    for view in self.fieldView.subviews
    {
      let xView = Double(view.x).getRoundedByPlaces(0)
      let xCompare = (x * 6.14).getRoundedByPlaces(0)
      let yView = Double(view.y).getRoundedByPlaces(0)
      let yCompare = (y * 7.37).getRoundedByPlaces(0)
      if  xView == xCompare && yView == yCompare {
        view.removeFromSuperview()
      }
    }
  }
  
  
  
  func readJSON(index:Int) -> Dictionary<String,AnyObject>
  {
    let path = NSBundle.mainBundle().pathForResource("plays", ofType: "json")
    let jsonData = NSData(contentsOfFile: path!)
    
    do
    {
      let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! [AnyObject]
      
      return jsonArray[index] as! Dictionary<String,AnyObject>
    }
    catch{}
    
    return [:]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}


extension UIView {
  
  func setBackgroundImage(image: UIImage) {
    let imageView = UIImageView(frame: self.frame)
    imageView.image = image
//    imageView.
    self.addSubview(imageView)
    self.sendSubviewToBack(imageView)
  }
  
  func makeQuarterBack()
  {
    self.layer.borderColor = UIColor.redColor().CGColor
    self.layer.backgroundColor = UIColor.redColor().CGColor
  }
  func makeCircular() {
    let cntr:CGPoint = self.center
    self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
    self.layer.borderColor = UIColor.whiteColor().CGColor
    self.layer.borderWidth = 3
    self.layer.shadowOffset = CGSize(width: 10, height: 10)
    let shadowPath = UIBezierPath(rect: self.bounds)
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOffset = CGSize(width: 2, height: 2)
    self.layer.shadowOpacity = 0.2
    self.layer.shadowPath = shadowPath.CGPath
    self.center = cntr
  }
}