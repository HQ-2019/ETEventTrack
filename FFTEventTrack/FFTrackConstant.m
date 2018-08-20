//
//  FFTrackConstant.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "FFTrackConstant.h"

@implementation FFTrackConstant

NSString *const KConfigFileName = @"FFEventTrackConfig";                    /**< 配置文件名称 */
NSString *const KConfigKeyVersion = @"EventTrackVersion";                   /**< 配置文件版本key */
NSString *const KConfigKeyAllEvents = @"EventTrackItems";                   /**< 配置文件所有事件配置信息 */
NSString *const KConfigKeyPageId = @"PageEventId";                          /**< 配置文件页面key */
NSString *const KConfigKeyControlId = @"ControlEventId";                    /**< 配置文件页面下的控件key */

NSString *const KEventTypeAppLaunch = @"baboonsLaunch";                     /**< 程序启动 */
NSString *const KEventTypeAppFisrtLaunch = @"baboonsInstall";               /**< 程序安装 */
NSString *const KEventTypeAppEnterForeground = @"baboonsLaunch";            /**< 程序进入前台 */
NSString *const KEventTypeAppEnterBackground = @"baboonsAppExit";           /**< 程序进入后台 */
NSString *const KEventTypePage = @"baboonsPage";                            /**< 页面类型 */
NSString *const KBuryPointTypeClick = @"baboonsClick";                      /**< 点击类型 */
NSString *const KEventTypeAppLogin = @"baboonsLogin";                       /**< 登录 */
NSString *const KEventTypeRegister = @"baboonsRegister";                    /**< 注册登录 */
NSString *const KEventTypeEnter = @"baboonsPageEnter";                      /**< 进入页面 */
NSString *const KEventTypeDuration = @"duration";
NSString *const KEventTypeClick = @"click";                                 /**< 点击类型 */
NSString *const KEventTypeView = @"view";                                   /**< 曝光类型 */
NSString *const KEventTypeSlide = @"slide";                                 /**<滑动 */
NSString *const KEventTypeInput = @"input";                                 /**<输入 */

NSString *const KEventKeyEventType = @"buryPointType";                      /**< 事件类型 */
NSString *const KEventKeyPageId = @"pageId";                                /**< 页面id */
NSString *const KEventType = @"eventType";                                  /**< 事件类型 0：曝光，1：点击；2：输入，3：元素滑动 */
NSString *const KElementID = @"elementId";                                  /**< 元素id */
NSString *const KExtMap = @"extMap";

NSString *const KEventKeyClickId = @"buttonType";                            /**< 点击id */
NSString *const KEventKeyContent = @"elementContent";                        /**< 内容 */

@end
