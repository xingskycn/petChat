#Project files struct
-(DIR)ROOT
|-(DIR)Pet
 |-(DIR)Class
  |-(DIR)Common //common管理
   |-(DIR)UIHelper //Image管理
   |-(DIR)FMDBManager //database管理
   |-(DIR)AFNetWorking //网络请求管理
   |-(DIR)XMPP IM管理
  |-(DIR)Controller //视图控制器
   |-(DIR)Chat //聊天
   |-(DIR)Contacts //联系人
   |-(DIR)Discover //发现
    |-(DIR)Discover_club //发现_俱乐部    |-(DIR)Discover_event //发现_活动    |-(DIR)Discover_game //发现_游戏    |-(DIR)Discover_group //发现_群组    |-(DIR)Discover_news //发现_动态    |-(DIR)Discover_shout //发现_喊话
   |-(DIR)Merchants //周边
   |-(DIR)Near //附近
    |-(DIR)Fliter //筛选    |-(DIR)NearDetail //附近_详情    |-(DIR)NearUI //附近UI
   |-(DIR)Setting //设置
   |-(DIR)Login&Register //登陆&注册
  |-(DIR)Models //模型
  |-(DIR)Libs //类库
   |-(DIR)JSONKit //Json
   |-(DIR)Animations //动作
   |-(DIR)EGO //刷新、加载
   |-(DIR)TMQuiltView //瀑布流
  |-(UIApplicationDelegate)PEAppDelegate //启动
  |-(UITabBarController)PERootViewController //根视图控制器
  |-(Xcassets)Images
  |-(Xcdatamodeld)Pet
 |-(DIR)Supporting Files
  |-(plist)Pet-Info
  |-(strings)InfoPlist
  |-(m)main
  |-(pch)Pet-Prefix
  |-(strings)Localizable(en,cn)
 |-(DIR)Images
|-(DIR)PetTest
|-(DIR)Products
|-(Config)Pods.xcconfig


CocoaPods:
pod 'AFNetworking', '~> 2.2.4'
pod 'XMPPFramework', '~> 3.6.4'
pod 'FMDB', '~> 2.3'
pod 'IQKeyboardManager', '~> 3.0.5'
pod 'SIAlertView', '~> 1.3'
pod 'EAIntroView', '~> 2.6.1' William HU tested for Jack Wu user