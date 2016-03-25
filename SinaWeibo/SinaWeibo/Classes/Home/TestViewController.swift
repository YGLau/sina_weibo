//
//  TestViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/25/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 设置标题
        navigationItem.title = "我的名片"
        // 添加图片容器
        view.addSubview(iconView)
        // 布局图片容器
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        iconView.backgroundColor = UIColor.redColor()
        // 生成二维码
        let qrCodeImage = createCodeImage()
        
        // 将生成好的二维码图片添加到容器上
        iconView.image = qrCodeImage
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     生成一张二维码
     */
    private func createCodeImage() -> UIImage {
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        // 3.设置需要生成二维码的数据
        filter?.setValue("刘勇刚".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        // 4.从滤镜中取出生成好的图片
        let image = filter?.outputImage
        // 合成一样高清图片
        let gqImage = createNonInterpolatedUIImageFormCIImage(image!, size: 300)
        // 创建一张头像
        let iconImage = UIImage(named: "01.jpg")
        // 合成图片
        let resImage = createImage(gqImage, icon: iconImage!)
        
        return resImage
        
    }
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    /**
     将两张图片合成一张图片
     
     - parameter bgImage: 背景图片
     - parameter icon:    中间的头像
     
     - returns: 合成后的图片
     */
    private func createImage(bgImage:UIImage, icon:UIImage) ->UIImage {
        // 开启一个图形上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        // 合成头像
        let iconW:CGFloat = 50.0
        let iconH:CGFloat = iconW
        let iconX = (bgImage.size.width - iconW) * 0.5
        let iconY = (bgImage.size.height - iconH) * 0.5
        icon.drawInRect(CGRect(x: iconX, y: iconY, width: iconW, height: iconH))
        // 取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        // 返回生成好的图片
        return newImage
        
    }
    // MARK: - 懒加载
    private lazy var iconView:UIImageView = UIImageView()

}
