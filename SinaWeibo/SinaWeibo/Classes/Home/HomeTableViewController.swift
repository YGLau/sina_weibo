//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/22/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

let YGHomeCellReuseIdentifier = "YGHomeCellReuseIdentifier"

class HomeTableViewController: BaseTableViewController {
    
    var statuses: [Status]?
    {
        didSet{
            // 当别人设置完毕数据, 就刷新表格
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.设置导航条
        setupNav()
        
        // 3.监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationChange), name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationChange), name: PopoverAnimatorWillDismiss, object: nil)
        
        // 4.注册两个cell
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        
        // 5.添加下拉刷新控件
        refreshControl = HomeRefreshControl()
        
        // 去除分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 加载数据
        loadData()
        
    }
    /**
     获取微博数据
     */
    private func loadData() {
        Status.loadStatuses { (models, error) in
            if error != nil {
                return
            }
            self.statuses = models
        }
        
    }
    
    func notificationChange() {
        //修改按钮的状态
        let titleBtn = navigationItem.titleView as! titleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    private func setupNav() {
        // 设置导航条的未登录按钮
        // 1.左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightBtnClick))
        // 2.中间的 view
        navigationItem.titleView = titleView
    }

    private lazy var titleView:titleButton = {
        let titleBtn = titleButton()
        titleBtn.setTitle("首页标题 ", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return titleBtn
    }()
    
    func titleBtnClick(btn:titleButton)
    {
//        btn.selected = !btn.selected
        // 弹出菜单
        let sb = UIStoryboard(name:"PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        // 让PopoverAnimator对象成为代理
//        vc?.transitioningDelegate = popoverAnimator
        // 自定义 modal 样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftBtnClick()
    {
        
    }
    
    func rightBtnClick()
    {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    /// 微博行高的缓存, 利用字典作为容器. key就是微博的id, 值就是对应微博的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat] ()
    
    override func didReceiveMemoryWarning() {
        // 清除缓存
        rowCache.removeAll()
    }
}
//MARK: - 数据源方法
extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取 Cell
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell
        // 取出模型
        cell.status = status
        
        return cell
        
    }
    /**
     返回行高
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 1.取出对应行的模型
        let status = statuses![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id]{
            return height
        }
        
        // 3.拿到 Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
        
        return rowHeight
        
    }
    
    
}



