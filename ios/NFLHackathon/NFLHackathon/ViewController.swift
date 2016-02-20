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
  
  enum Team
  {
    case Home
    case Away
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //6.141666667
    //7.373358349
    
    let sample = self.readJSON()
    
    self.parsePlayersTracking(.Home,sample: sample)
    self.parsePlayersTracking(.Away,sample: sample)
    
  }
  
  func parsePlayersTracking(team:Team,sample: Dictionary<String, AnyObject>)
  {
    var players = Array<AnyObject>()
    var seconds = 0
    var color = UIColor()
    switch team
    {
    case .Home:
      players = sample["homeTrackingData"] as! Array<AnyObject>
      color = .orangeColor()
      break
      
    case .Away:
      players = sample["awayTrackingData"] as! Array<AnyObject>
      color = .blueColor()
      
      break
    }
    
    let timer = NSTimer.runThisEvery(seconds: 0.1) { (timer) -> Void in
      for player in players
      {
        if seconds == player["playerTrackingData"]!!.count
        {
          timer.invalidate()
          seconds = seconds - 1
        }
        let x = player["playerTrackingData"]!![seconds]["x"]
        let y = player["playerTrackingData"]!![seconds]["y"]
        
        
        if seconds > 0
        {
          let xPrevious = player["playerTrackingData"]!![seconds - 1]["x"]
          let yPrevious = player["playerTrackingData"]!![seconds - 1]["y"]
          self.removeFromField(xPrevious as! Double, y: yPrevious as! Double)
        }
        self.addToFIeld(x as! Double, y: y as! Double,team:team)
        
      }
      
      seconds++
    }
    
  }
  
  func addToFIeld(x:Double,y:Double,team:Team)
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
  
  
  
  func readJSON() -> Dictionary<String,AnyObject>
  {
    let path = NSBundle.mainBundle().pathForResource("sample", ofType: "json")
    let jsonData = NSData(contentsOfFile: path!)
    
    do
    {
      let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers)
      
      return jsonDict as! Dictionary<String,AnyObject>
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
  func makeCircular() {
    let cntr:CGPoint = self.center
    self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
    self.center = cntr
  }
}