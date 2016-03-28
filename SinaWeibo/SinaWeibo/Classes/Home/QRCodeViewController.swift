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
    
    /// 我的名片
    @IBAction func myCardBtnClick(sender: AnyObject) {
        // push 到名片控制器
        let QRVc = QRCodeCardViewController()
        navigationController?.pushViewController(QRVc, animated: true)
        
    }
    
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
        
        // 开始扫描
        startScan()
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
        
    }
    /**
     冲击波动画
     */
    func startAnimation() {
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
        
        // 添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)
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
    
    // 创建用于绘制边线的图层
    private lazy var drawLayer:CALayer = {
        let layer = CALayer()
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
        // 1.获取扫描到的位置
        
        // 2.获取扫描到的二维码的位置
        // 2.1 转换坐标
        for object in metadataObjects {
            // 2.1.1 判断当前获取到的数据,是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject {
                // 2.1.2 将坐标转换成可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                // 2.1.3 绘制图形
                drawCorners(codeObject)
            }
        }
        
    }
    /**
     绘制图形
     */
    private func drawCorners(codeObject:AVMetadataMachineReadableCodeObject) {
        
        // 0.清除图层
        clearRectangleLine()
        
        if codeObject.corners.isEmpty {
            return
        }
        // 1.创建图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        // 2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var i:Int = 0
        // 2.1 移动一个点
        // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[i++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        // 2.2 移动到其他点
        while i < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[i++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        // 2.3 关闭路径
        path.closePath()
        // 2.4 绘制路径
        layer.path = path.CGPath
        // 3.将绘制好的图层添加到 DrawLayer上
        drawLayer.addSublayer(layer)
        
    }
    /**
    *  清除边线
    */
    private func clearRectangleLine() {
        // 1.判断 drawLayer 上是否有其他图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        // 2.移除
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
