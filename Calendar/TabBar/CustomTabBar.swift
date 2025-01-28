//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Keihan Kamangar on 2021-06-07.
//

import UIKit

class CustomTabBar: UITabBar {
    
    // MARK: - Variables
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 72, height: 72)
        
        let image = UIImage(named: "plus")!
        middleButton.setImage(image, for: .normal)
        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = .init(red: 191/255, green: 114/255, blue: 255/255, alpha: 1)
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 36
        
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
      self.isTranslucent = true
      self.backgroundColor = .clear // here is your tabBar color

      let blurEffect = UIBlurEffect(style: .dark) // here you can change blur styl
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.frame = self.bounds
      blurView.alpha = 0.5
      blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.insertSubview(blurView, at: 0)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        middleButton.center = CGPoint(x: frame.width / 2, y: 20)
      
        let topBorder = CALayer()
        let borderHeight: CGFloat = 1
        topBorder.borderWidth = borderHeight
        topBorder.borderColor = UIColor.init(white: 255/255, alpha: 0.05).cgColor
        topBorder.frame = CGRect(x: 0, y: -1, width: self.frame.width, height: borderHeight)

        layer.addSublayer(topBorder)
      
        self.addSubview(middleButton)
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}
