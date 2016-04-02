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
        // 添加监听
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        
        // 去除分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 加载数据
        loadData()
        
    }
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false
    /**
     获取微博数据
     */
    @objc private func loadData() {
        
        /*
         1.默认最新返回20条数据
         2.since_id : 会返回比since_id大的微博
         3.max_id: 会返回小于等于max_id的微博
         
         每条微博都有一个微博ID, 而且微博ID越后面发送的微博, 它的微博ID越大
         递增
         
         新浪返回给我们的微博数据, 是从大到小的返回给我们的
         */
 
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        if pullupRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
 
        Status.loadStatuses(since_id, max_id: max_id) { (models, error) in
            // 结束刷新
            self.refreshControl?.endRefreshing()
            if error != nil {
                return
            }
            if since_id > 0 {
                // 如果是下拉刷新, 就将获取到的数据, 拼接在原有数据的前面
                self.statuses = models! + self.statuses!
                // 显示刷新提示
                self.showNewStatusCount(models?.count ?? 0)
            } else if max_id > 0{
                // 如果是上拉加载更多, 就将获取到的数据, 拼接在原有数据的后面
                self.statuses = self.statuses! + models!
            } else {
                self.statuses = models
            }
        }
        
    }
    
    private func showNewStatusCount(count: Int) {
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        UIView.animateWithDuration(1, animations: {
            
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            
            }) { (_) in
                UIView.animateWithDuration(1, animations: {
                    // 清空
                    self.newStatusLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) in
                        
                        self.newStatusLabel.hidden = true
                        
                })
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
    //MARK: - 懒加载
    private lazy var titleView:titleButton = {
        let titleBtn = titleButton()
        titleBtn.setTitle("首页标题 ", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return titleBtn
    }()
    // 刷新提醒控件
    private lazy var newStatusLabel: UILabel = {
        let label = UILabel()
        let height:CGFloat = 44
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        label.backgroundColor = UIColor.orangeColor()
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        label.hidden = true
        return label
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
        
        // 判断是否滚动到最后一个Cell
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1) {
            pullupRefreshFlag = true
            loadData()
        }
        
        
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



