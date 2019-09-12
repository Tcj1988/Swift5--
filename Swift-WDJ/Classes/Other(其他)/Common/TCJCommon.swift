//
//  TCJCommon.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

// MARK:- 自定义print
func TCJPrint(_ item : Any, file : String = #file, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("fileName:\(fileName)" + "\t" + "lineNum:\(lineNum)" + "\t" + "\(item)")
    #endif
}

// MARK:- 界面布局
/// 屏幕宽度
public let kScreenWidth:CGFloat = UIScreen.main.bounds.width
/// 屏幕高度
public let kScreenHeight:CGFloat = UIScreen.main.bounds.height
public let kScreenScale:CGFloat = UIScreen.main.scale
/// 状态栏高度
public let kStatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height
/// 导航栏高度
public let kNavigationBarHeight:CGFloat = kStatusBarHeight + 44
/// tabBar高度
public let kTabBarHeight:CGFloat = 49
/// 工具栏高度
public let kToolBarHeight:CGFloat = 44
/// 是否是iPhone X系列
public let isIPhoneX:Bool = (UIApplication.shared.statusBarFrame.size.height > 20)

/// cell间距
public let kTopicCellMargin:CGFloat = 10
/// cell顶部视图高度
public let kTopicCellTopViewHeight:CGFloat = 70
/// cell底部视图高度
public let kTopicCellBottomViewHeight:CGFloat = 49
/// 热评视图高度
public let kTopicCellHotCommentViewHeight:CGFloat = 60
/// 用户头像大小
public let kTopicCellUserIconWidth:CGFloat = 50
/// 正文字体大小
public let kContentTextFontSize:CGFloat = 15
/// 摘要字体大小
public let kSummarizeTextFontSize:CGFloat = 12

// MARK:- 网络接口
/// 服务器地址
public let kBaseURLString:String = "https://api.budejie.com/"
/// 获取帖子信息接口
public let kTopicListAPI:String = "api/api_open.php"
/// 获取推荐关注列表接口
public let kNewTopicRecommendAPI:String = "api/api_open.php"
/// 我的模块功能列表接口
public let kSquareListAPI:String = "api/api_open.php"
/// 获取“推荐关注”中左侧标签的列表接口
public let kRecommendCategoryAPI:String = "api/api_open.php"
/// 获取“推荐关注”中左侧标签每个标签对应的推荐用户组接口
public let kRecommendItemAPI:String = "api/api_open.php"

// MARK: - 通知相关

/// 帖子cell点击通知
public let kTopicCellDidTapNotification:String = "kTopicCellDidTapNotification"
/// 帖子类型key
public let kTopicTypeKey:String = "kTopicTypeKey"
/// 帖子视图模型key
public let kTopicViewModelKey:String = "kTopicViewModelKey"
