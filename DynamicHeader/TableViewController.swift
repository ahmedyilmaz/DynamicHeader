//
//  ViewController.swift
//  DynamicHeader
//
//  Created by xeon on 19.04.2020.
//  Copyright © 2020 xeon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var statusBar = UIView()
    var data = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSetup()
        
    }
    
    func loadSetup() {
        loadTransparentNavigation()
        addMoreData()
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.imageView.alpha = 1.0
        })
    }
    
    func addMoreData() {
        for _ in 0...8 {
            data.append(data[0])
        }
    }
    
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ImageTransitionRatio = CGFloat(2)
        guard let navigationController = self.navigationController else { return }
        let scrollAlphaOffset = CGFloat(imageView.frame.height - (navigationController.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height))
        
        
        if scrollView.contentOffset.y <= imageView.frame.height {
            
            self.imageView.alpha = 1 - (scrollView.contentOffset.y / scrollAlphaOffset)
            self.imageView.frame = CGRect(x: 0, y: (scrollView.contentOffset.y/ImageTransitionRatio) > 0 ? (scrollView.contentOffset.y/ImageTransitionRatio) : 0 , width: self.imageView.frame.width, height: self.imageView.frame.height)
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(scrollView.contentOffset.y/scrollAlphaOffset)]
                        
            if scrollView.contentOffset.y > scrollAlphaOffset  || scrollView.contentOffset.y < 0 {
            self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent((scrollView.contentOffset.y/scrollAlphaOffset))
            self.statusBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent((scrollView.contentOffset.y/scrollAlphaOffset))
            }
            
        }
        
    }
    
    func alphaCalculator(offset: CGFloat , texOffset: CGFloat) -> CGFloat {
         var alpha = CGFloat()
         if offset > 0  {
            alpha = ((offset-texOffset) / texOffset) < 1.0 ? ((offset-texOffset) / texOffset) : 1.0
         } else {
            alpha = 0.0
         }
        return alpha
    }
    
}
//MARK: TABLEVIEW METHODS
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = data[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

//MARK: NAVIGATION BAR SETUP
extension TableViewController {
    
    func loadTransparentNavigation() {
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.0)]
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13, *)
        {
            statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if navigationController.navigationBar.isTranslucent, #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets.top = -navigationController.navigationBar.bounds.height
        }
    }
}
