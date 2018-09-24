//
//  FFTrackConstant.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETConstants.h"

@implementation ETConstants

NSString *const ETConfigFileName = @"FFEventTrackConfig";                    /**< 配置文件名称 */
NSString *const ETConfigKeyVersion = @"EventTrackVersion";                   /**< 配置文件版本key */
NSString *const ETConfigKeyTimeInterval = @"EventTrackTimeInterval";         /**< 配置文件定时上传埋点信息的时间间隔 */
NSString *const ETConfigKeyAllEvents = @"EventTrackItems";                   /**< 配置文件所有事件配置信息 */
NSString *const ETConfigKeyPageId = @"PageEventId";                          /**< 配置文件页面key */
NSString *const ETConfigKeyControlId = @"ControlEventId";                    /**< 配置文件页面下的控件key */

NSString *const ETEventTypeAppLaunch = @"baboonsLaunch";                     /**< 程序启动 */
NSString *const ETEventTypeAppFisrtLaunch = @"baboonsInstall";               /**< 程序安装 */
NSString *const ETEventTypeAppEnterForeground = @"baboonsLaunch";            /**< 程序进入前台 */
NSString *const ETEventTypeAppEnterBackground = @"baboonsAppExit";           /**< 程序进入后台 */
NSString *const ETEventTypePage = @"baboonsPage";                            /**< 页面类型 */
NSString *const ETBuryPointTypeClick = @"baboonsClick";                      /**< 点击类型 */
NSString *const ETEventTypeAppLogin = @"baboonsLogin";                       /**< 登录 */
NSString *const ETEventTypeRegister = @"baboonsRegister";                    /**< 注册登录 */
NSString *const ETEventTypeEnter = @"baboonsPageEnter";                      /**< 进入页面 */
NSString *const ETEventTypeDuration = @"duration";
NSString *const ETEventTypeClick = @"click";                                 /**< 点击类型 */
NSString *const ETEventTypeView = @"view";                                   /**< 曝光类型 */
NSString *const ETEventTypeSlide = @"slide";                                 /**< 滑动 */
NSString *const ETEventTypeInput = @"input";                                 /**< 输入 */

NSString *const ETEventKeyEventType = @"buryPointType";                      /**< 事件类型 */
NSString *const ETEventKeyPageId = @"pageId";                                /**< 页面id */
NSString *const ETEventType = @"eventType";                                  /**< 事件类型 0：曝光，1：点击；2：输入，3：元素滑动 */
NSString *const ETElementID = @"elementId";                                  /**< 元素id */
NSString *const ETExtMap = @"extMap";

NSString *const ETEventKeyClickId = @"buttonType";                            /**< 点击id */
NSString *const ETEventKeyContent = @"elementContent";                        /**< 内容 */

@end
