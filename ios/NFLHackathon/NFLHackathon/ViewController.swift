//
//  ViewController.swift
//  NFLHackathon
//
//  Created by Lucas Farah on 2/20/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var viewSliders: UIView!
  @IBOutlet weak var fieldView: UIView!
  @IBOutlet weak var lblTime: UILabel!
  @IBOutlet weak var shadowView: UIView!
  
  @IBOutlet weak var barChart: UISlider!
  @IBOutlet weak var bar2Chart: UISlider!
  @IBOutlet weak var bar3Chart: UISlider!
  
  @IBOutlet weak var barChart2: UISlider!
  @IBOutlet weak var bar2Chart2: UISlider!
  @IBOutlet weak var bar3Chart2: UISlider!
  
  
  @IBOutlet weak var barChart3: UISlider!
  @IBOutlet weak var bar2Chart3: UISlider!
  @IBOutlet weak var bar3Chart3: UISlider!
  
  @IBOutlet weak var lblPercentagr: UILabel!
  @IBOutlet weak var lblPercentagr2: UILabel!
  
  @IBOutlet weak var lblPercentage3: UILabel!
  
  var timerSliders = NSTimer()
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
    
    let probabilities = readAlgorithm(0)
    self.viewSliders.hidden = false
    //    self.changeSliderTo((probabilities["1"]!["probability"]?.doubleValue)!)
    //    self.changeSlider2To((probabilities["2"]!["probability"]?.doubleValue)!)
    //    self.changeSlider3To((probabilities["3"]!["probability"]?.doubleValue)!)
    
    //    lblTime.setCornerRadius(radius: 10)
    //    lblTime.addBorder(width: 3, color: .whiteColor())
    
    //    self.viewSliders.setCornerRadius(radius: 10)
    //    self.viewSliders.addBorder(width: 4, color: .whiteColor())
    //    let shadowPath = UIBezierPath(rect: self.viewSliders.bounds)
    //    self.viewSliders.layer.masksToBounds = false
    //    self.viewSliders.layer.shadowColor = UIColor.blackColor().CGColor
    //    self.viewSliders.layer.shadowOffset = CGSize(width: 2, height: 2)
    //    self.viewSliders.layer.shadowOpacity = 0.2
    //    self.viewSliders.layer.shadowPath = shadowPath.CGPath
    
  }
  
  @IBOutlet weak var showHideSliders: UIButton!
  
  //  func simulateSliders()
  //  {
  //    let arrSliderValue = [0.4,0.9,0.1,0.3,0.2,0.8]
  //    let arrSliderValue2 = [0.9,0.4,0.1,0.5,0.7,0.2]
  //    let arrSliderValue3 = [0.6,0.3,0.1,0.1,0.8,0.5]
  //    
  //    var count = 0
  //    self.timerSliders = NSTimer.runThisEvery(seconds: 2) { (timer) -> Void in
  //      if count < arrSliderValue.count
  //      {
  //        self.changeSliderTo(arrSliderValue[count])
  //        self.changeSlider2To(arrSliderValue2[count])
  //        self.changeSlider3To(arrSliderValue3[count])
  //        
  //        count++
  //      }
  //      else
  //      {
  //        self.timerSliders.invalidate()
  //      }
  //    }
  //  }
  @IBAction func showHideSliders(sender: AnyObject)
  {
    if self.viewSliders.hidden
    {
      self.viewSliders.hidden = false
      showHideSliders.setBackgroundImage(UIImage())
    }
    else
    {
      self.viewSliders.hidden = true
      self.timerSliders.invalidate()
      showHideSliders.setBackgroundImage(UIImage(named: "force touch icon")!)
    }
  }
  func changeSliderTo(val:Int)
  {
    let value = val.toDouble
    UIView.animateWithDuration(0.1, animations: { () -> Void in
      self.barChart.setValue(self.barChart.value, animated: true)
      self.bar2Chart.setValue(self.bar2Chart.value, animated: true)
      self.bar3Chart.setValue(self.bar3Chart.value, animated: true)
      
      }) { (bol) -> Void in
        UIView.animateWithDuration(1, animations: { () -> Void in
          self.barChart.setValue(Float(value), animated: true)
          self.bar2Chart.setValue(Float(value), animated: true)
          self.bar3Chart.setValue(Float(value), animated: true)
          
          self.lblPercentagr.text = "\(self.barChart.value)%"
          }, completion: nil)
    }
  }
  func changeSlider2To(val:Int)
  {
    let value = val.toDouble
    
    UIView.animateWithDuration(0.1, animations: { () -> Void in
      self.barChart2.setValue(self.barChart2.value, animated: true)
      self.bar2Chart2.setValue(self.bar2Chart2.value, animated: true)
      self.bar3Chart2.setValue(self.bar3Chart2.value, animated: true)
      
      }) { (bol) -> Void in
        UIView.animateWithDuration(1, animations: { () -> Void in
          self.barChart2.setValue(Float(value), animated: true)
          self.bar2Chart2.setValue(Float(value), animated: true)
          self.bar3Chart2.setValue(Float(value), animated: true)
          
          self.lblPercentagr2.text = "\(self.barChart2.value)%"
          }, completion: nil)
    }
  }
  func changeSlider3To(val:Int)
  {
    let value = val.toDouble
    
    UIView.animateWithDuration(0.1, animations: { () -> Void in
      self.barChart3.setValue(self.barChart3.value, animated: true)
      self.bar2Chart3.setValue(self.bar2Chart3.value, animated: true)
      self.bar3Chart3.setValue(self.bar3Chart3.value, animated: true)
      
      }) { (bol) -> Void in
        UIView.animateWithDuration(1, animations: { () -> Void in
          self.barChart3.setValue(Float(value), animated: true)
          self.bar2Chart3.setValue(Float(value), animated: true)
          self.bar3Chart3.setValue(Float(value), animated: true)
          self.lblPercentage3.text = "\(self.barChart3.value)%"
          }, completion: nil)
    }
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
        let secods = (Double(seconds) * 0.1).getRoundedByPlaces(1)
        self.lblTime.text = "\(secods)"
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
    
    var count = players[0]["trackingData"]!!.count
    if seconds < count
    {
      for player in players
      {
        //        //Fixing player tracking sensor
        //        if player["trackingData"]!!.count < count
        //        {
        //          count = player["trackingData"]!!.count
        //        }
        if seconds < player["trackingData"]!!.count
        {
          let x = player["trackingData"]!![seconds]["x"]
          let y = player["trackingData"]!![seconds]["y"]
          
          guard let track = player["trackingData"]!![seconds] else
          {
            return
          }
          if let isOffense = track["isOffense"] where isOffense != nil
          {
            let offStr = "\(isOffense as! NSNumber)"
            if offStr.toInt() == 1
            {
//              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
//                {
//                  // Task
//                  dispatch_async(dispatch_get_main_queue())
//                    {
//                      //UI
                      self.changeSliderTo(player["trackingData"]!![seconds]["score"] as! Int)
                      self.changeSlider2To(player["trackingData"]!![seconds]["synergy"] as! Int)
                      self.changeSlider3To(player["trackingData"]!![seconds]["score"] as! Int)
//                  }
//              }
          }
          
          }
          
          if seconds > 0
          {
            let xPrevious = player["trackingData"]!![seconds - 1]["x"]
            let yPrevious = player["trackingData"]!![seconds - 1]["y"]
            self.removeFromField(xPrevious as! Double, y: yPrevious as! Double)
          }
          let dic = player as! [String:AnyObject]
          if let id = player["nflId"]
          {
            let strId = "\(id)"
            if strId.toInt() == 71281 || strId.toInt() == 2495312
            {
              self.addToFIeld(x as! Double, y: y as! Double,team:team, playerType: .Quarterback)
            }
            else
            {
              self.addToFIeld(x as! Double, y: y as! Double,team:team, playerType: .Other)
            }
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
        let probabilities = readAlgorithm(play + 1)
        self.viewSliders.hidden = false
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
    let path = NSBundle.mainBundle().pathForResource("analysis-4", ofType: "json")
    let jsonData = NSData(contentsOfFile: path!)
    
    do
    {
      let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! [AnyObject]
      
      return jsonArray[index] as! Dictionary<String,AnyObject>
    }
    catch{}
    
    return [:]
  }
  
  func readAlgorithm(index:Int) -> Dictionary<String,Dictionary<String,AnyObject>>
  {
    let path = NSBundle.mainBundle().pathForResource("data1", ofType: "json")
    let jsonData = NSData(contentsOfFile: path!)
    do
    {
      let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! [AnyObject]
      
      return jsonArray[index] as!  Dictionary<String,Dictionary<String,AnyObject>>
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
    //    self.layer.backgroundColor = UIColor.redColor().CGColor
    self.w = 30
    self.h = 30
    self.makeCircular()
    self.layer.borderColor = UIColor.yellowColor().CGColor
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