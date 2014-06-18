//
//  MessageNode.h
//  HitCat
//
//  Created by apple01 on 2014. 6. 2..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "GameLayer.h"

// miss, correct, bonus 정보를 보여주는 메시지 노드
@interface MessageNode : CCNode
{
	// 각각의 정보를 보여주기 위한 스프라이트 노드의 사용
	CCSprite *miss;
	CCSprite *correct;
//	CCSprite *bonus;
//    CCLabelBMFont *combo;
	
	BOOL missVisible;
	BOOL correctVisible;
//	BOOL bonusVisible;
//    BOOL comboVisible;
}

// 각 메시지 정보의 상수선언
extern int const MISS_MESSAGE;
extern int const CORRECT_MESSAGE;
//extern int const COMBO_MESSAGE;
//extern int const BONUS_MESSAGE;
@property (nonatomic, retain) CCSprite *miss;
@property (nonatomic, retain) CCSprite *correct;
//@property (nonatomic, retain) CCLabelBMFont *combo;
//@property (nonatomic, retain) CCSprite *bonus;
-(void)showMessage:(int) message;
@end

