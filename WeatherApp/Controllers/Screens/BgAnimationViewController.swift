//
//  BgAnimationViewController.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

/* ======================================================================== */
/// Developer: Arya Sreenivasan
/// Usage: For Wipro Test project
/// This class is created for the dynamic background
    ///   - Day with sun's rays & cloud
    ///   - Night with star animation
/// Only used Native methods (no third party)
/// For Day:
    ///   -- Used images & translations
/// For Night
    ///   -- Used CAEmitterCell
/// This will be changes while changing the city
/// and also in the 15 day's data displaying page
/* ======================================================================== */

enum OutsideTime:String {
    case Day
    case Night
}

class BgAnimationViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var bgColorView: UIView?
    @IBOutlet var cloudImageView:UIImageView?
    @IBOutlet var raysBg:UIImageView?
    
    //MARK:- Variables
    var starEmitterLayer:CAEmitterLayer?
    var selectedWeather:Weather = Weather([:]) { //From parent VC
        didSet {
            configureBackgroundTheme()
        }
    }
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.cloudImageView?.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.configureBackgroundTheme()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureBackgroundTheme() 
    }
    
    //MARK:- Animation configurations
    func configureBackgroundTheme() {
        stopLayerAnimations()
        
        let outsideTime:OutsideTime = (selectedWeather.date > selectedWeather.sys.sunset) ? .Night : .Day 
        switch outsideTime {
        case .Day:
            bgColorView?.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.5568627451, blue: 0.7764705882, alpha: 1)
            raysBg?.alpha = 1
            cloudImageView?.alpha = 1
            displayDayTheme()
        case .Night:
            bgColorView?.backgroundColor = #colorLiteral(red: 0.139228642, green: 0.1695723236, blue: 0.4355647564, alpha: 1)
            raysBg?.alpha = 0
            cloudImageView?.alpha = 0
            displayNightStars()
        }
     }
    
    func stopLayerAnimations() {
        if (starEmitterLayer != nil) {
            starEmitterLayer?.removeAllAnimations()
            starEmitterLayer?.removeFromSuperlayer()
        }
        cloudImageView?.transform = CGAffineTransform.init(translationX: 0, y: 0)
    }
    
    @objc func displayNightStars() {
        stopLayerAnimations()
        
        let starEmitterCell = CAEmitterCell()
        starEmitterCell.color = UIColor.init(white: 1, alpha: 0.5).cgColor
        starEmitterCell.contents = UIImage(named: "starDot")?.cgImage
        starEmitterCell.scale = 0.4
        starEmitterCell.scaleRange = 0.7
        starEmitterCell.emissionRange = .pi
        starEmitterCell.lifetime = 10.0
        starEmitterCell.lifetimeRange = 0.5
        starEmitterCell.birthRate = 100
        starEmitterCell.velocityRange = 2
        starEmitterCell.yAcceleration = -0.5
        starEmitterCell.xAcceleration = -0.5
        starEmitterCell.alphaRange = 0.3;
        starEmitterCell.alphaSpeed  = 0.5;
        
        starEmitterLayer = CAEmitterLayer()
        if let _starEmitterLayer = starEmitterLayer {
            _starEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
            _starEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: view.bounds.height)
            _starEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.rectangle
            _starEmitterLayer.emitterCells = [starEmitterCell]
            self.view.layer.addSublayer(_starEmitterLayer)
        }
    }
    
    func displayDayTheme() {
        UIView.animate(withDuration: 25.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            var transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            transform = transform.concatenating(CGAffineTransform.init(translationX: 200, y: 30))
            self.cloudImageView?.transform = transform
        }) { (status) in
            
        }
    }

}
