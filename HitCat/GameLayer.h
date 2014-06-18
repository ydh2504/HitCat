//
//  GameLayer.h
//  HitCat
//
//  Created by apple01 on 2014. 5. 22..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"
#import "MessageNode.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"
@interface GameLayer : CCLayer {
    int checkScore;
    float catSpeed;
    int life;
    int combo;
    BOOL checkCombo;
    CCSprite *hitEffect;
    CCSprite *player;
    CCSprite *ptLifeSprite;
    CCProgressTimer *ptLife;
    CCAnimate *playerAnimate;
    CCAnimate *hitEffectAnimate;
    CCArray *catArray;
    CCArray *itemArray;
    NSInteger gameScore;
    NSInteger gameCombo;
    CCLabelBMFont *lblScore;//화면에 점수를 나타낼 label
    CCLabelBMFont *lblCombo;
    MessageNode *message;
    AppController<UIApplicationDelegate> *appDelegate;
    
}
@property(nonatomic, retain) MessageNode *message;
//@property(nonatomic, readonly) NSInteger *gameCombo;
+(CCScene *) scene;
@end
