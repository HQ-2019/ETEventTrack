//
//  FFTrackConstant.h
//  ETEventTrack
//FOUNDATION_EXPORT
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETConstants : NSObject

FOUNDATION_EXPORT NSString *const ETConfigFileName;                      /**< 配置文件名称 */
FOUNDATION_EXPORT NSString *const ETConfigKeyVersion;                    /**< 配置文件版本key */
FOUNDATION_EXPORT NSString *const ETConfigKeyTimeInterval;               /**< 配置文件定时上传埋点信息的时间间隔 */
FOUNDATION_EXPORT NSString *const ETConfigKeyAllEvents;                  /**< 配置文件所有事件配置信息 */
FOUNDATION_EXPORT NSString *const ETConfigKeyPageId;                     /**< 配置文件页面key */
FOUNDATION_EXPORT NSString *const ETConfigKeyControlId;                  /**< 配置文件页面下的控件key */

FOUNDATION_EXPORT NSString *const ETEventTypeAppLaunch;                  /**< 程序启动 */
FOUNDATION_EXPORT NSString *const ETEventTypeDuration;
FOUNDATION_EXPORT NSString *const ETEventTypeAppFisrtLaunch;
FOUNDATION_EXPORT NSString *const ETEventTypeAppEnterForeground;         /**< 程序进入前台 */
FOUNDATION_EXPORT NSString *const ETEventTypeAppEnterBackground;         /**< 程序进入后台 */
FOUNDATION_EXPORT NSString *const ETEventTypePage;                       /**< 页面类型 */
FOUNDATION_EXPORT NSString *const ETEventTypeClick;                      /**< 点击类型 */
FOUNDATION_EXPORT NSString *const ETEventTypeInput;                      /**< 输入 */
FOUNDATION_EXPORT NSString *const ETEventTypeRegister;                   /**< 注册登录 */
FOUNDATION_EXPORT NSString *const ETEventTypeAppLogin;                   /**< 登录 */
FOUNDATION_EXPORT NSString *const ETEventTypeEnter;

FOUNDATION_EXPORT NSString *const ETBuryPointTypeClick;                  /**< 点击类型 */
FOUNDATION_EXPORT NSString *const ETBuryPointTypeView;                   /**< 曝光类型 */
FOUNDATION_EXPORT NSString *const ETBuryPointTypeSlide;                  /**< 滑动 */
FOUNDATION_EXPORT NSString *const ETBuryPointTypeeInput;                 /**< 输入 */

FOUNDATION_EXPORT NSString *const ETEventKeyEventType;                   /**< 事件类型 */
FOUNDATION_EXPORT NSString *const ETEventKeyPageId;                      /**< 页面id */
FOUNDATION_EXPORT NSString *const ETEventTypeClick;                      /**< 点击类型 1*/
FOUNDATION_EXPORT NSString *const ETEventTypeView;                       /**< 曝光类型0 */
FOUNDATION_EXPORT NSString *const ETEventTypeSlide;                      /**< 滑动 3*/
FOUNDATION_EXPORT NSString *const ETEventType;
FOUNDATION_EXPORT NSString *const ETElementID;                           /**< 元素id */
FOUNDATION_EXPORT NSString *const ETExtMap;

FOUNDATION_EXPORT NSString *const ETEventKeyClickId;                     /**< 点击id */
FOUNDATION_EXPORT NSString *const ETEventKeyContent;                     /**< 内容 */

@end
