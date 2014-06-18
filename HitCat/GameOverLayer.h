//
//  GameOverLayer.h
//  Fly Hunter
//
//  Created by JungTong 51310 on 2014. 5. 2..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "MenuScene.h"
#import "AppDelegate.h"

@interface GameOverLayer : CCLayer {
    CCMenuItem *gameOverImage;
    CCMenuItem *againImage;
    CCLabelTTF *scoreLabel;
    
    AppController<UIApplicationDelegate> *appDelegate;
}
@property (nonatomic, retain) CCLabelTTF *scoreLabel;

@end