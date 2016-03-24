//
//  QRCodeViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/24/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    // 关闭
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /// 底部 TabBar


    @IBOutlet weak var customTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 默认进来选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
