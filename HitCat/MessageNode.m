//
//  MessageNode.m
//  HitCat
//
//  Created by apple01 on 2014. 6. 2..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import "MessageNode.h"
@implementation MessageNode

// 각 메시지의 상수 선언으로 enum 타입으로 수정하여도 무방할 듯 함
int const MISS_MESSAGE = 0;
int const CORRECT_MESSAGE = 1;
//int const BONUS_MESSAGE = 2;
//int const COMBO_MESSAGE = 2;
@synthesize miss, correct;
-(id) init {
    
	self = [super init];
	if (self) {
        
		// 현재 노드에 miss, correct, bonus 스프라이트 노드를 자식 노드로 추가
		CCSprite *m = [[CCSprite alloc] initWithFile:@"miss.png"];
		//[m setAnchorPoint:ccp(0,0)];
		self.miss = m;
		[m release];
		[self addChild:miss];
		
		CCSprite *c = [[CCSprite alloc] initWithFile:@"hit.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.correct = c;
		[c release];
		[self addChild:correct];
		
//		CCSprite *b = [[CCSprite alloc] initWithFile:@"bonus.png"];
//		//[c setAnchorPoint:ccp(0,0)];
//		self.bonus = b;
//		[b release];
//		[self addChild:bonus];
        
//        CCLabelBMFont *com = [CCLabelBMFont labelWithString:@"COMBO 0!" fntFile:@"testFont.fnt"];
//        [com setAnchorPoint:ccp(0.5f, 0.5f)];
//        [com setPosition:ccp(240, 160)];
//        [com setScale:1];
//        self.combo = com;
//        [com release];
//        [self addChild:combo z:10];
		
		// 각각의 노드에 대한 위치는 화면의 중앙 상단으로 한다
		miss.position = ccp(240, 240);
		correct.position = ccp(240, 260);
//		bonus.position = ccp(240, 260);
//        combo.position = ccp(240, 160);
		
        //처음엔 안보임
        correct.visible = NO;
        miss.visible = NO;
//        bonus.visible = NO;
//        combo.visible = NO;
	}
	
	return self;
}

// showMessage 메소드는 int를 매개변수로 받아서 각 스프라이트를 지역변수 sprite에 할당함.
- (void) showMessage:(int) message
{
	CCSprite *sprite;
    CCSprite *sprite2;

//    CCLabelBMFont *lable;
	
	if(message == MISS_MESSAGE)
	{
		sprite = miss;
		missVisible = YES;
        sprite2 = correct;
        correctVisible = NO;
	}else if(message == CORRECT_MESSAGE)
	{
		sprite = correct;
		correctVisible = YES;
        sprite2 = miss;
        missVisible = NO;
	}
//    else if(message == BONUS_MESSAGE)
//	{
//		sprite = bonus;
//		bonusVisible = YES;
//	}
//    else if(message == COMBO_MESSAGE)
//    {
//       lable = combo;
//        comboVisible = YES;
//    }
    [sprite stopAllActions];
    sprite.visible = YES;
    sprite.position = ccp( 240, 260);
    sprite2.visible=NO;
//    lable.visible = YES;
//    lable.position = ccp(240, 160);
    
	// 짧은 순간에 opacity값을 0으로 만들어서 투명한 스프라이트를 만든다
	[sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
	
    // 순차적인 액션을 보여줌
	[sprite runAction:[CCSequence actions:
                       [CCFadeTo actionWithDuration:0.1 opacity:250],
                       [CCScaleTo actionWithDuration:0.3 scale:1.5],
                       [CCDelayTime actionWithDuration:1.2],
                       [CCMoveTo actionWithDuration:0.2 position:ccp(240, 550)],
                       [CCFadeTo actionWithDuration:0.1 opacity:0],
					   nil]];
    
//    [lable runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
//	
//    // 순차적인 액션을 보여줌
//	[lable runAction:[CCSequence actions:
//                       [CCFadeTo actionWithDuration:0.1 opacity:250],
//                       [CCScaleTo actionWithDuration:0.3 scale:1.5],
//                       [CCDelayTime actionWithDuration:1.2],
//                       [CCFadeTo actionWithDuration:0.1 opacity:0],
//					   nil]];
}

- (void) dealloc
{
	[correct release];
	[miss release];
//	[bonus release];
//    [combo release];
	[super dealloc];
}
@end

