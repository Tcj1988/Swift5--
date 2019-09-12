//
//  TCJTopicTableVC.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

/// 视频cell重用标识符
public let kVideoTopicTableViewCellReuseIdentifier:String = "TCJVideoTopicTableViewCell"
/// 声音cell重用标识符
public let kVoiceTopicTableViewCellReuseIdentifier:String = "TCJVoiceTopicTableViewCell"
/// 图片cell重用标识符
public let kPictureTopicTableViewCellReuseIdentifier:String = "TCJPictureTopicTableViewCell"
/// 段子cell重用标识符
public let kWordTopicTableViewCellReuseIdentifier:String = "TCJWordTopicTableViewCell"

class TCJTopicTableVC: UITableViewController {

    /// 帖子列表视图模型
    private lazy var topicListViewModel = TCJTopicListViewModel()
    
    // MARK: - 公开方法
    
    /// 帖子类型
    open var topicType:TCJTopicType {
        return .All
    }
    
    /// 是否是新帖列表
    open var isNewTopicList:Bool {
        return false
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 设置tableView
        setUpTableView()
        // 刷新数据
        tableView.mj_header.beginRefreshing()
    }

}

// MARK: - 其他方法

private extension TCJTopicTableVC
{
    /// 设置tableView
    func setUpTableView() -> Void
    {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        
        // 取消默认64偏移
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 注册cell
        registerTableCell()
        
        // 设置下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewTopicList))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        // 设置上拉刷新
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTopicList))
        
        // 设置边距
        let topMargin = kNavigationBarHeight + (isNewTopicList ? 0 : kToolBarHeight)
        tableView.contentInset = UIEdgeInsets(top: topMargin, left: 0, bottom: kTopicCellBottomViewHeight + tableView.mj_footer.height, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    /// 注册cell
    func registerTableCell() -> Void
    {
        tableView.register(TCJPictureTopicTableViewCell.self, forCellReuseIdentifier: kPictureTopicTableViewCellReuseIdentifier)
        tableView.register(TCJVideoTopicTableViewCell.self, forCellReuseIdentifier: kVideoTopicTableViewCellReuseIdentifier)
        tableView.register(TCJVoiceTopicTableViewCell.self, forCellReuseIdentifier: kVoiceTopicTableViewCellReuseIdentifier)
        tableView.register(TCJWordTopicTableViewCell.self, forCellReuseIdentifier: kWordTopicTableViewCellReuseIdentifier)
    }
    
    /// 根据视图模型返回对应的cell重用标识符
    ///
    /// - Parameter topicViewModel: 视图模型
    /// - Returns: cell重用标识符
    func reuseIdentifierWithTopicModel(topicViewModel:TCJTopicViewModel) -> String
    {
        switch topicViewModel.type {
        case .Picture:
            return kPictureTopicTableViewCellReuseIdentifier
        case .Video:
            return kVideoTopicTableViewCellReuseIdentifier
        case .Voice:
            return kVoiceTopicTableViewCellReuseIdentifier
        case .Word:
            return kWordTopicTableViewCellReuseIdentifier
        case  .All:
            return kWordTopicTableViewCellReuseIdentifier
        }
    }
}

// MARK: - 加载数据相关

private extension TCJTopicTableVC
{
    /// 加载最新帖子
    @objc func loadNewTopicList() -> Void
    {
        let minId = topicListViewModel.topicList.first?.topicId ?? 0
        
        topicListViewModel.loadTopicList(type: topicType, isNewTopicList: isNewTopicList, minId: minId) { (isSuccess) in
            self.tableView.mj_header.endRefreshing()
            if !isSuccess {
                TCJPrint("加载自定义帖子失败")
                SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络连接~")
                return
            }
            
            // 刷新表格
            self.tableView.reloadData()
        }
    }
    
    /// 加载更多数据
    @objc func loadMoreTopicList() -> Void
    {
        let count = topicListViewModel.topicList.count
        let maxId = topicListViewModel.topicList.last?.topicId ?? 0
        
        topicListViewModel.loadTopicList(type: topicType, isNewTopicList: isNewTopicList,maxId: maxId) { (isSuccess) in
            count == self.topicListViewModel.topicList.count ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : self.tableView.mj_footer.endRefreshing()
            if !isSuccess {
                TCJPrint("加载自定义帖子失败")
                SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络连接~")
                return
            }
            
            // 刷新表格
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension TCJTopicTableVC
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.mj_footer.isHidden = (topicListViewModel.topicList.count == 0)
        return topicListViewModel.topicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let topicViewModel = topicListViewModel.topicList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierWithTopicModel(topicViewModel: topicViewModel)) as! TCJBaseTopicTableViewCell
        cell.topicViewModel = topicViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return topicListViewModel.topicList[indexPath.row].rowHeight
    }
}
