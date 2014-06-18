//
//  IntroLayer.m
//  HitCat
//
//  Created by apple01 on 2014. 5. 22..
//  Copyright __MyCompanyName__ 2014년. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameLayer.h"
#import "SceneManager.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background z:-2];
	
	// In one second transition to the new scene
	
}

-(id) init {
    if(self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"title-hd.png"];
        [background setPosition:ccp(160,470)];
        [self addChild:background z:10];
        
        gameOverImage = [CCMenuItemImage itemFromNormalImage:@"main-hd.png"
                                               selectedImage:@"main-hd.png"
                                                      target:self
                                                    selector:@selector(makeTransition:)];
        
        CCMenu *menu = [CCMenu menuWithItems: gameOverImage, nil];
        menu.position = CGPointMake(240,160 );
        [self addChild:menu z:0];
        id moveAction = [CCJumpTo actionWithDuration:1.0f position:ccp(240, 160) height:-120 jumps:1];
        id scaleUpDown = [CCCallFuncN actionWithTarget:self selector:@selector(moveUpDown:)];
       
        id action = [CCSequence actions:moveAction, scaleUpDown, nil];
        [background runAction:action];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm1.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
    }
    return self;
}
-(void)moveUpDown:(id)sender
{
	//NSLog(@"menuMove1 sender=%@", sender);
    //	[self moveUpDown:sender withOffset:60];
    
    // CCMoveBy에 의해 상대적인 위치로 이동한다
	id moveRotate = [CCRotateTo actionWithDuration:0.5 angle:3.0f];
	id moveReverseRotate = [CCRotateTo actionWithDuration:0.5 angle:-3.0f];
	// 아래위 움직임을 반복한다
	id moveUpDown = [CCSequence actions:moveRotate, moveReverseRotate, nil];
	
	[sender runAction:[CCRepeatForever actionWithAction:moveUpDown]];
}
-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[MenuScene node] withColor:ccWHITE]];
}
@end
