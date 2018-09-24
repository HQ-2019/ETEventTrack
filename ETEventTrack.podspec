#
#  Be sure to run `pod spec lint ETEventTrack.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name         = "ETEventTrack" # 项目名称
    s.version      = "1.0.2"        # 版本号 与 你仓库的 标签号 对应
    s.license      = "MIT"          # 开源证书
    s.summary      = "iOS项目埋点基础框架" # 项目简介

    s.homepage     = "https://github.com/willn1987/ETEventTrack" # 主页
    s.source       = { :git => "https://github.com/willn1987/ETEventTrack.git", :tag => "#{s.version}" } # 仓库地址，不能用SSH地址
    # s.source_files = "ETEventTrack/*.{h,m}" # 代码的位置， ETEventTrack/*.{h,m} 表示 ETEventTrack文件夹下所有的.h和.m文件
    s.source_files = "ETEventTrack/**/*" # 代码的位置
    s.requires_arc = true # 需要ARC
    s.platform     = :ios, "8.0" # 平台及支持的最低版本
    s.frameworks   = "UIKit", "Foundation" # 支持的框架

    # 依赖库
    s.dependency 'AFNetworking', '~> 3.2.1'
    s.dependency 'SensorsAnalyticsSDK'

    # User
    s.author             = { "willn1987" => "391690874@qq.com" } # 作者信息
    s.social_media_url   = "https://github.com/willn1987" # 个人主页

end
