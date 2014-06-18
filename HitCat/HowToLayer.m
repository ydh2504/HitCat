//
//  HowToLayer.m
//  HitCat
//
//  Created by apple01 on 2014. 6. 11..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import "HowToLayer.h"
#import "MenuScene.h"


@implementation HowToLayer
@synthesize backButton;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [HowToLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// sprite 객체인 back을 생성한다.(배경 이미지 파일과 위치를 지정한다.)
        howTo  = [CCSprite spriteWithFile:@"howToLayer-hd.png"];
        //[back setAnchorPoint:ccp(0.5f, 0.5f)];
        [howTo setPosition:ccp(size.width/2, size.height/2)];
		
		[self addChild:howTo z:0];
        
        backButton = [CCMenuItemImage itemWithNormalImage:@"icon_back.png"
                                           selectedImage:@"icon_back.png"
                                                  target:self
                                                selector:@selector(backScene:)];
        
        backButton.position = ccp(size.width * 5/6 + 12, size.height/7*6);
        [backButton setAnchorPoint:ccp(0.5f, 0.5f)];
        backButton.scale = 0.9f;
//        id scaleUpDown1 = [CCCallFuncN actionWithTarget:self selector:@selector(moveUpDown:)];
//		id action1 = [CCSequence actions:scaleUpDown1, nil];
//		[backButton runAction:action1];
        

        
        CCMenu *menu = [CCMenu menuWithItems:self.backButton, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
        
	}
	return self;
}


-(void)backScene:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
}

@end
