//
//  QRCodeViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/24/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, UITabBarDelegate {
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 中间容器的高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    // 关闭
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /// 冲击波顶部约束
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    /// 底部 TabBar


    @IBOutlet weak var customTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 默认进来选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // view 即将出现时执行动画
        startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 { // 二维码
            containerHeightCons.constant = 300
        } else { // 条形码
            containerHeightCons.constant = 150
        }
        
        // 停止动画
        scanLineView.layer.removeAllAnimations()
        // 开始动画
        startAnimation()
        
        // 开始扫描
        startScan()
    }
    /**
     冲击波动画
     */
    private func startAnimation() {
        // 让约束从顶部开始
        scanLineTopCons.constant = -containerHeightCons.constant
        scanLineView.layoutIfNeeded()
        
        // 执行冲击波动画
        UIView.animateWithDuration(2.0) { () -> Void in
            self.scanLineTopCons.constant = self.containerHeightCons.constant
            // 动画的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 强制更新界面
            self.scanLineView.layoutIfNeeded()
        }
        
    }
    /**
     开始扫描
     */
    private func startScan() {
        // 判断能否拿到输入设备
        if !session.canAddInput(deviceInput) {
            return
        }
        // 判断能否拿到输出设备
        if !session.canAddOutput(deviceOutput) {
            return
        }
        // 将输入输出设备添加会话中
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        // 设置输出能够解析的类型
        deviceOutput.metadataObjectTypes = deviceOutput.availableMetadataObjectTypes
        // 设置输出对象的代理,只要能解析成功就会通知代理
        deviceOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // 添加图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        // 告诉 session 开始扫描
        session.startRunning()
        
    }
    
    //MARK: - 懒加载
    // 创建会话
    private lazy var session:AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    // 输入设备
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        // 获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // 创建输入对象
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch {
            print(error)
            return nil
        }
        
    }()
    // 输出设备
    private lazy var deviceOutput:AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        return output
    }()
    // 创建预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
        
    }()
    


}
// MARK: - 代理方法
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate {
    /**
     解析到数据就会调这个方法
     */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        print(metadataObjects.last?.stringValue)
        
    }
    
}
