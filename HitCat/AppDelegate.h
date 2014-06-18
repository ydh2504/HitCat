//
//  AppDelegate.h
//  HitCat
//
//  Created by apple01 on 2014. 5. 22..
//  Copyright __MyCompanyName__ 2014년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
    NSInteger   gameScore;
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readwrite) NSInteger gameScore;
@end
