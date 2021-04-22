//
//  DesignablesManager.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

//======================================//
/*  This class is created to hold the   */
/*  Reusable subclasses/IBDesignables   */
/*  Author: Arya Sreenivasan            */
//======================================//

//========================================================
// CustomView: Created to customize UI elements
//========================================================
@IBDesignable
class CustomView: UIView {
    
    override open func draw(_ rect: CGRect) {
        setCornerRadius()
        setAsCircle()
        setBorderWidth()
        setBorderColor()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable
    var isCircle: Bool = false {
        didSet {
            setAsCircle()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            setBorderColor()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0{
        didSet {
            setBorderWidth()
        }
    }
    
    private func setCornerRadius() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    private func setAsCircle() {
        if (isCircle) {
            self.layer.cornerRadius = self.frame.size.height/2.0
        }
        self.clipsToBounds = true
    }
    
    private func setBorderColor() {
        self.layer.borderColor = borderColor.cgColor
    }
    
    private func setBorderWidth() {
        self.layer.borderWidth = borderWidth
    }
    
}

//========================================================
// CustomViewShadow: Created to customize view with shadows
//========================================================
@IBDesignable
class CustomViewShadow: UIView {
    
    override open func draw(_ rect: CGRect) {
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.masksToBounds = false
    }
    
    @IBInspectable public var shadowRadius:CGFloat = 0.0 {
        didSet{
            setShadowRadius()
        }
    }
    
    @IBInspectable public var shadowColour:UIColor = UIColor.gray{
        didSet{
            setShadowColour()
        }
    }
    
    @IBInspectable public var shadowOffset:CGSize = CGSize(width: 0, height: 0){
        didSet{
            setShadowOffset()
        }
    }
    
    @IBInspectable public var shadowOpacity:Float = 0.3 {
        didSet{
            setShadowOpacity()
        }
    }
    
    private func setShadowRadius() {
        self.layer.shadowRadius = shadowRadius
    }
    
    private func setShadowColour() {
        self.layer.shadowColor = shadowColour.cgColor
    }
    
    private func setShadowOffset() {
        self.layer.shadowOffset = shadowOffset
    }
    
    private func setShadowOpacity() {
        self.layer.shadowOpacity = shadowOpacity
    }
}

//========================================================
// CustomViewGradient: Created to customize view with shadows
//========================================================
@IBDesignable
class CustomViewGradient: CustomView {
    
    var colourStart:UIColor = UIColor.gray
    var colourEnd:UIColor = UIColor.darkGray
    var startPoint:CGPoint = CGPoint(x: 0, y: 0)
    var endPoint:CGPoint = CGPoint(x: 0, y: 0)
    var layerTopGradient:CAGradientLayer?
    
    override open func draw(_ rect: CGRect) {
        applyGradient()
    }
    
    override func layoutSubviews() {
        layerTopGradient?.frame = self.bounds
    }
    
    @IBInspectable
    public var ColourStart:UIColor = UIColor.gray{
        didSet{
            colourStart = ColourStart;
        }
    }
    
    @IBInspectable
    public var ColourEnd:UIColor = UIColor.darkGray{
        didSet{
            colourEnd = ColourEnd;
        }
    }
    
    @IBInspectable
    public var StartPoint:CGPoint = CGPoint(x: 0.5, y: 0){
        didSet{
            startPoint = StartPoint;
        }
    }
    
    @IBInspectable
    public var EndPoint:CGPoint = CGPoint(x: 0.5, y: 1){
        didSet{
            endPoint = EndPoint;
        }
    }
    
    func applyGradient() {
        if let layerGra = layerTopGradient{
            layerGra.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            layerGra.startPoint = startPoint
            layerGra.endPoint = endPoint
            layerGra.colors = [colourStart.cgColor,colourEnd.cgColor]
        }else{
            layerTopGradient = CAGradientLayer()
            layerTopGradient?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            layerTopGradient?.startPoint = startPoint
            layerTopGradient?.endPoint = endPoint
            layerTopGradient?.colors = [colourStart.cgColor,colourEnd.cgColor]
            self.layer.insertSublayer(layerTopGradient!, at: 0)
        }
    }
     
}
