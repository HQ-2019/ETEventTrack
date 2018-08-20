//
//  FFTrackConstant.h
//  FFTwoBaboons
//FOUNDATION_EXPORT
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFTrackConstant : NSObject

FOUNDATION_EXPORT NSString *const KConfigFileName;                      /**< 配置文件名称 */
FOUNDATION_EXPORT NSString *const KConfigKeyVersion;                    /**< 配置文件版本key */
FOUNDATION_EXPORT NSString *const KConfigKeyAllEvents;                  /**< 配置文件所有事件配置信息 */
FOUNDATION_EXPORT NSString *const KConfigKeyPageId;                     /**< 配置文件页面key */
FOUNDATION_EXPORT NSString *const KConfigKeyControlId;                  /**< 配置文件页面下的控件key */

FOUNDATION_EXPORT NSString *const KEventTypeAppLaunch;                  /**< 程序启动 */
FOUNDATION_EXPORT NSString *const KEventTypeDuration;
FOUNDATION_EXPORT NSString *const KEventTypeAppFisrtLaunch;
FOUNDATION_EXPORT NSString *const KEventTypeAppEnterForeground;         /**< 程序进入前台 */
FOUNDATION_EXPORT NSString *const KEventTypeAppEnterBackground;         /**< 程序进入后台 */
FOUNDATION_EXPORT NSString *const KEventTypePage;                       /**< 页面类型 */
FOUNDATION_EXPORT NSString *const KEventTypeClick;                      /**< 点击类型 */
FOUNDATION_EXPORT NSString *const KEventTypeInput;                      /**<输入 */
FOUNDATION_EXPORT NSString *const KEventTypeRegister;                   /**< 注册登录 */
FOUNDATION_EXPORT NSString *const KEventTypeAppLogin;                   /**< 登录 */
FOUNDATION_EXPORT NSString *const KEventTypeEnter;

FOUNDATION_EXPORT NSString *const KBuryPointTypeClick;                  /**< 点击类型 */
FOUNDATION_EXPORT NSString *const KBuryPointTypeView;                   /**< 曝光类型 */
FOUNDATION_EXPORT NSString *const KBuryPointTypeSlide;                  /**<滑动 */
FOUNDATION_EXPORT NSString *const KBuryPointTypeeInput;                 /**<输入 */

FOUNDATION_EXPORT NSString *const KEventKeyEventType;                   /**< 事件类型 */
FOUNDATION_EXPORT NSString *const KEventKeyPageId;                      /**< 页面id */
FOUNDATION_EXPORT NSString *const KEventTypeClick;                      /**< 点击类型 1*/
FOUNDATION_EXPORT NSString *const KEventTypeView;                       /**< 曝光类型0 */
FOUNDATION_EXPORT NSString *const KEventTypeSlide;                      /**<滑动 3*/
FOUNDATION_EXPORT NSString *const KEventType;
FOUNDATION_EXPORT NSString *const KElementID;                           /**< 元素id */
FOUNDATION_EXPORT NSString *const KExtMap;

FOUNDATION_EXPORT NSString *const KEventKeyClickId;                     /**< 点击id */
FOUNDATION_EXPORT NSString *const KEventKeyContent;                     /**< 内容 */

@end
