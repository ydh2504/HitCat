//
//  CreditLayer.h
//  HitCat
//
//  Created by apple01 on 2014. 6. 11..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuScene.h"
#import "SceneManager.h"

@interface CreditLayer : CCLayer {
    CCMenuItem *backButton;
    CCSprite *credit;
}
+(CCScene *) scene;
@property (nonatomic, retain) CCMenuItem *backButton;
@end

