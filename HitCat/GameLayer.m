//
//  GameLayer.m
//  HitCat
//
//  Created by apple01 on 2014. 5. 22..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#define INIT_SCORE          (0)
#define INIT_COMBO          (0)

#define MAX_LIFE_COUNT 3

@implementation GameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
enum {
    kTagMessage = 100,
};
@synthesize message;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        catArray = [[CCArray alloc]init];
        itemArray = [[CCArray alloc]init];
        [self initGameNumber];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"swing.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"meow.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.wav"];
        //배경음악을 위한 음악을 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.7f];
        
        //사운드 효과의 음량을 0.5로 지정합니다.
        
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        NSLog(@"size x = %f size y = %f",size.width,size.height);
        
		// sprite 객체인 back을 생성한다.(배경 이미지 파일과 위치를 지정한다.)
        CCSprite *back = [CCSprite spriteWithFile:@"background-hd.png"];
        //[back setAnchorPoint:ccp(0.5f, 0.5f)];
        [back setPosition:ccp(size.width/2, size.height/2)];
		
		[self addChild:back z:0];
        
        [self schedule:@selector(createSchedule)];
        
        self.isTouchEnabled = YES;
        [self createPlayer];
        [self createEffect];
        //        lblScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gameScore] fontName:@"Marker Felt" fontSize:32];
        //
        //        //레이블의 색상을 지정합니다.
        //        lblScore.color = ccc3(0,0,255);
        //
        //        //레이블의 anchorPoint와 위치를 지정합니다.
        //        lblScore.anchorPoint = ccp(1, 0.5f);
        //        lblScore.position =ccp(460,30);
        //
        //        //레이블을 GameLayer의 자식으로 추가하고 z 값을 9로 지정합니다.
        //        [self addChild:lblScore z:9];
        
        lblScore = [CCLabelBMFont labelWithString:@"SCORE : 0" fntFile:@"testFont.fnt"];
        [lblScore setAnchorPoint:ccp(0, 0.5)];
        [lblScore setPosition:ccp(5, 310)];
        [lblScore setScale:3];
        [self addChild:lblScore z:9];
        
        //        lblCombo = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gameCombo]
        //            fontName:@"Marker Felt" fontSize:20];
        //        lblCombo.color = ccc3(255,0,0);
        //
        //        //레이블의 anchorPoint와 위치를 지정합니다.
        //        lblCombo.anchorPoint = ccp(0.5f, 0.5f);
        //        lblCombo.position =ccp(240,160);
        //
        //        //레이블을 GameLayer의 자식으로 추가하고 z 값을 9로 지정합니다.
        //        [self addChild:lblCombo z:10];
        
        lblCombo = [CCLabelBMFont labelWithString:@"COMBO 0!" fntFile:@"testFont.fnt"];
        [lblCombo setAnchorPoint:ccp(0.5f, 0.5f)];
        [lblCombo setPosition:ccp(240, 240)];
        [lblCombo setScale:3];
        [self addChild:lblCombo z:10];
        lblCombo.visible = NO;
        
        MessageNode *mess = [[MessageNode alloc] init];
        self.message = mess;
        [mess release];
        [self addChild:message z:100 tag:kTagMessage];
        
        ptLifeSprite = [CCSprite spriteWithFile:@"life.png"];
        
        //총알의 개수를 막대형식의 바(bar)로 나타내는 ptBullet의 이미지를 위에서 정의한 ptBulletSprite로 지정합니다.
        ptLife = [CCProgressTimer progressWithSprite:ptLifeSprite];
        
        //ptBullet의 형태를 오른쪽에서 왼쪽으로 줄어드는 수평막대 형으로 지정합니다.
        ptLife.type = kCCProgressTimerTypeBar;
        
        //ptBullet의 anchorPoint와 위치를 지정합니다.
        ptLife.anchorPoint = ccp(0.5f, 0.5f);
        ptLife.position = ccp(size.width-40, size.height-10);
        
        //ptBullet의 총알 이미지가 줄어드는 형태를 지정해주는 옵션입니다. ccp(1,0)으로 지정하면 가로로 이미지가 줄어들고 ccp(0,1)로 지정하면 세로로 이미지가 줄어듭니다.
        ptLife.barChangeRate = ccp(1,0);
        
        //ptBullet의 총알 이미지가 줄어드는 방향(왼쪽 또는 오른쪽)을 지정해주는 옵션입니다. ccp(0,1)이면 오른쪽부터 이미지가 줄어들고 ccp(1,0)이면 왼쪽부터 이미지가 줄어듭니다.
        ptLife.midpoint = ccp(0,1);
        
        //ptBullet의 비율을 100으로 잡습니다.
        ptLife.percentage=100;
        
        //ptBullet을 GameLayer의 자식으로 둡니다. z 값은 21로 지정합니다.
        [self addChild:ptLife z:21];
        
	}
	return self;
}

- (void)createSchedule{
    if(gameScore <= 0 && checkScore== 0){
        [self schedule:@selector(randomCreate) interval:1.5f];
        [self schedule:@selector(createCat1) interval:1.35f];
        [self schedule:@selector(createItem) interval:5.0f];
        checkScore++;
        catSpeed = 3.0f;
    } else if (gameScore >= 1000 && checkScore == 1){
        [self unschedule:@selector(randomCreate)];
        [self schedule:@selector(randomCreate) interval:1.0f];
        [self unschedule:@selector(createItem)];
        [self schedule:@selector(createItem) interval:4.0f];
        checkScore++;
        catSpeed = 2.0f;
    } else if (gameScore >= 5000 && checkScore == 2){
        [self unschedule:@selector(randomCreate)];
        [self schedule:@selector(randomCreate) interval:0.7f];
        [self unschedule:@selector(createItem)];
        [self schedule:@selector(createItem) interval:3.0f];
        checkScore++;
        catSpeed = 1.0f;
    } else if (gameScore >= 10000 && checkScore == 3){
        [self unschedule:@selector(randomCreate)];
        [self schedule:@selector(randomCreate) interval:0.5f];
        checkScore++;
        catSpeed = 0.8f;
    } else if (gameScore >= 50000 && checkScore == 4){
        [self unschedule:@selector(randomCreate)];
        [self schedule:@selector(randomCreate) interval:0.25f];
        catSpeed = 0.5f;
        checkScore++;
    }
}

- (void)initGameNumber
{
    // AppController의 gameScore도 동시에 초기화시킨다.
    appDelegate.gameScore = gameScore = INIT_SCORE;
    checkCombo = NO;
    life = 3;
    checkScore = 0;
    
}

-(CGPoint)getStartPosition {
    
    int starty=0;
    
    // arc4random()은 랜덤으로 정수인 값을 줍니다.
    // 'arc4random()%x' 이면 0에서 x-1 값중에 하나를 줍니다.
    // x 좌표가 -30 에서 509 중에 나오도록 랜덤을 설정합니다.
    // 새 sprite 크기를 계산해서 화면에 안 보이게 하기 위해 화면 x 범위 (0 ~ 480) 보다 더 크게 잡았습니다.
    int startx = 500;
    
    // 위에서 설정한 랜덤값이 0 보다 크고 480보다 작다면, 즉 x좌표가 화면에 보일 수 있는 위치 안이라면 안보이도록 y 좌표를 400으로 합니다.(화면의 y 범위는 0 ~ 320 입니다.)
    // x값이 화면에서 안 보이는 위치에 있다면 y 좌표를 100에서 299중에 랜덤인 값으로 설정합니다.
    
    starty = arc4random()%220;
    
    
    // 랜덤으로 주어진 값을 반환합니다.
    return ccp(startx, starty);
}
-(void) createEffect{
    hitEffect = [[CCSprite alloc] init];
    
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:hitEffect z:6];
    
    NSMutableArray *hitEffectFrames = [NSMutableArray array];
    //애니메이션 객체 flyAnimation을 생성합니다.
    for(NSInteger i = 1; i < 10; i++) {
        CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Hit%04d.png",i]];
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:sprite.textureRect];
        [hitEffectFrames addObject:frame];
    }
    CCAnimation *hitEffectAnimation = [CCAnimation animationWithSpriteFrames:hitEffectFrames delay:0.05f];
    //CCAnimation에  action을 줄 CCAnimte를 만듭니다.
    hitEffectAnimate = [[CCAnimate alloc] initWithAnimation:hitEffectAnimation];
    
}
- (void)createItem {
    CCSprite *item = [CCSprite spriteWithFile:@"red.png"];
    
    [item setPosition:ccp(500, 160)];
    item.scale = 0.5;
    [self addChild:item z:5];
    
    [itemArray addObject:item];
    id actionItem = [CCMoveTo actionWithDuration:3.0f position:ccp(0, 160)];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeItem:)];
    id fadeOutItem = [CCFadeOut actionWithDuration:0.5f];
    id seqAction = [CCSequence actions:actionItem, fadeOutItem,moveComplete, nil];
    [item runAction:seqAction];
}

- (void)createPlayer{
    
    player = [[CCSprite alloc] init];
    player = [CCSprite spriteWithFile:@"player0001.png"];
    CGSize size = [[CCDirector sharedDirector] winSize];
    player.position = ccp(size.width/2-100, size.height/2);
    player.scale = 0.8;
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:player z:5];
    
    NSMutableArray *playerFrame = [NSMutableArray array];
    //애니메이션 객체 flyAnimation을 생성합니다.
    for(NSInteger i = 1; i < 11; i++) {
        CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"player%04d.png",i]];
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:sprite.textureRect];
        [playerFrame addObject:frame];
    }
    CCAnimation *playerAnimation = [CCAnimation animationWithSpriteFrames:playerFrame delay:0.03f];
    //CCAnimation에  action을 줄 CCAnimte를 만듭니다.
    playerAnimate = [[CCAnimate alloc] initWithAnimation:playerAnimation];
    
}
//전선 위로 날개짓을 하며 움직이는 새를 표현하는 메소드입니다.
- (void)createCat1 {
    
    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
    CCSprite *cat = [CCSprite spriteWithFile:@"yellowCat0001.png"];
    
    // bird 스프라이트의 위치를 지정합니다.
    [cat setPosition:[self getStartPosition]];
    
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:cat z:5];
    
    // birdArray 배열에 bird를 넣습니다.
    [catArray addObject:cat];
    
    //bird 객체의 retainCount를 1 감소시킵니다,
    //[bird release];
    
    //애니메이션 객체 flyAnimation을 생성합니다.
    CCAnimation *catAnimation = [CCAnimation animation];
    
    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
    for(NSInteger i = 1; i < 5; i++) {
        [catAnimation addSpriteFrameWithFilename:[NSString       stringWithFormat:@"yellowCat%04d.png",i]];
    }
    [catAnimation setDelayPerUnit:0.1f];
    CCAnimation *catFishAnimation = [CCAnimation animation];
    for(NSInteger i = 1; i<5; i++){
        [catFishAnimation addSpriteFrameWithFilename:[NSString stringWithFormat:@"miss_yellowCat%04d.png",i]];
    }
    [catFishAnimation setDelayPerUnit:0.1f];
    float distance = ((player.position.y - cat.position.y)* 100.0f / 400.0f +player.position.y);
    
    //flyAnimation의 프레임당 시간 간격을 0.08초로 지정합니다.
    
    
    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
    id catAnimate = [CCAnimate actionWithAnimation:catAnimation];
    
    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
    id actionCatrepeat = [CCRepeatForever actionWithAction:catAnimate];
    
    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
    [cat runAction:actionCatrepeat];
    
    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
    id actionMoveTo    = [CCMoveTo actionWithDuration:(catSpeed*0.8) position:ccp(player.position.x - 40, 160)];
    
    id actionMoveTo2 = [CCMoveTo actionWithDuration:(catSpeed*0.2) position:ccp(0,distance)];
    
    id catChangeAnimation = [CCAnimate actionWithAnimation:catFishAnimation];
    id repeatCatFish = [CCRepeat actionWithAction:catChangeAnimation times:((int)(catSpeed) + 1)];
    id moveCat = [CCSpawn actions:actionMoveTo2,repeatCatFish, nil];
    id lifeLoss = [CCCallFuncN actionWithTarget:self selector:@selector(lifeLoss)];
    id fadeOutCat = [CCFadeOut actionWithDuration:0.2f];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    
    id seqAction = [CCSequence actions:actionMoveTo,moveCat,fadeOutCat,moveComplete,lifeLoss, nil];
    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
    [cat runAction:seqAction];
}
- (void)createCat2 {
    
    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
    CCSprite *cat = [CCSprite spriteWithFile:@"blackCat0001.png"];
    
    // bird 스프라이트의 위치를 지정합니다.
    [cat setPosition:[self getStartPosition]];
    
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:cat z:5];
    
    // birdArray 배열에 bird를 넣습니다.
    [catArray addObject:cat];
    
    //bird 객체의 retainCount를 1 감소시킵니다,
    //[bird release];
    
    //애니메이션 객체 flyAnimation을 생성합니다.
    CCAnimation *catAnimation = [CCAnimation animation];
    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
    for(NSInteger i = 1; i < 5; i++) {
        [catAnimation addSpriteFrameWithFilename:[NSString       stringWithFormat:@"blackCat%04d.png",i]];
    }
    [catAnimation setDelayPerUnit:0.08f];
    
    CCAnimation *catFishAnimation = [CCAnimation animation];
    for(NSInteger i = 1; i<5; i++){
        [catFishAnimation addSpriteFrameWithFilename:[NSString stringWithFormat:@"miss_blackCat%04d.png",i]];
    }
    [catFishAnimation setDelayPerUnit:0.08f];
    
    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
    id catAnimate = [CCAnimate actionWithAnimation:catAnimation];
    
    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
    id actionCatrepeat = [CCRepeat actionWithAction:catAnimate times:((int)(catSpeed*3) + 1)];
    
    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
    [cat runAction:actionCatrepeat];
    float distance = ((player.position.y - cat.position.y)* 100.0f / 400.0f +player.position.y);
    
    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
    id actionMoveTo    = [CCMoveTo actionWithDuration:(catSpeed*0.8) position:ccp(player.position.x - 40, 160)];
    id fadeOut = [CCFadeOut actionWithDuration:0.2f];
    id fadeIn = [CCFadeIn actionWithDuration:0.2f];
    
    id fadeCat = [CCSequence actions:fadeOut,fadeIn, nil];
    id repeatFade = [CCRepeat actionWithAction:fadeCat times:((int)(catSpeed*2))];
    
    id moveCat2 = [CCSpawn actions:actionMoveTo,repeatFade, nil];
    
    id actionMoveTo2 = [CCMoveTo actionWithDuration:(catSpeed*0.2) position:ccp(0,distance)];
    id catChangeAnimation = [CCAnimate actionWithAnimation:catFishAnimation];
    id repeatCatFish = [CCRepeat actionWithAction:catChangeAnimation times:((int)(catSpeed)+ 1)];
    id moveCat3 = [CCSpawn actions:actionMoveTo2,repeatCatFish , nil];
    
    id lifeLoss = [CCCallFuncN actionWithTarget:self selector:@selector(lifeLoss)];
    id fadeOutCat = [CCFadeOut actionWithDuration:0.2f];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    
    id seqAction = [CCSequence actions:moveCat2,moveCat3,fadeOutCat,moveComplete,lifeLoss, nil];
    
    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
    [cat runAction:seqAction];
}
//- (void)createCat3 {
//
//    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
//    CCSprite *cat = [CCSprite spriteWithFile:@"time_0002.png"];
//
//    // bird 스프라이트의 위치를 지정합니다.
//    [cat setPosition:[self getStartPosition]];
//
//    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
//    [self addChild:cat z:5];
//
//    // birdArray 배열에 bird를 넣습니다.
//    [catArray addObject:cat];
//
//    //bird 객체의 retainCount를 1 감소시킵니다,
//    //[bird release];
//
//    //애니메이션 객체 flyAnimation을 생성합니다.
//    CCAnimation *catAnimation = [CCAnimation animation];
//
//    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
//    for(NSInteger i = 1; i < 3; i++) {
//        [catAnimation addSpriteFrameWithFilename:[NSString       stringWithFormat:@"time_%04d.png",i]];
//    }
//
//    //flyAnimation의 프레임당 시간 간격을 0.08초로 지정합니다.
//    [catAnimation setDelayPerUnit:0.04f];
//
//    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
//    id catAnimate = [CCAnimate actionWithAnimation:catAnimation];
//
//    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
//    id actionCatrepeat = [CCRepeatForever actionWithAction:catAnimate];
//
//    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
//    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
//    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
//    [cat runAction:actionCatrepeat];
//
//    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
//    id actionMoveTo    = [CCMoveTo actionWithDuration:1.0f position:ccp(0, 160)];
//
//    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
//    [cat runAction:actionMoveTo];
//}

-(void)randomCreate {
    NSInteger ran = arc4random()%2 + 1;
    
    switch (ran) {
        case 1:
            [self createCat1];
            NSLog(@"1");
            break;
        case 2 :
            [self createCat2];
            NSLog(@"2");
            break;
            //        case 3:
            //            NSLog(@"3");
            //            break;
            //        case 4:
            //            NSLog(@"4");
            //            break;
        default:
            NSLog(@"0");
            break;
    }
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    checkCombo = NO;
    NSLog(@"%d",checkCombo);
    // touch 라는 문구를 출력합니다.
    //    NSLog(@"touch");
    
    // 화면의 터치하는 곳의 좌표를 glLocation으로 정의하고 glLocation인 곳에서 연기를 나타내는 스프라이트인 gunSmoke를 나타나게합니다.
    //    UITouch *touch = [touches anyObject];
    //    CGPoint location = [touch locationInView:[touch view]];
    //    CGPoint glLocation = [[CCDirector sharedDirector] convertToGL:location];
    if (![playerAnimate isDone]) [player stopAction:playerAnimate];
    [player runAction:playerAnimate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"swing.wav"];
    //NSLog(@"%f,%f",glLocation.x,glLocation.y);
    //    [gunSmoke setPosition:glLocation];
    //
    //    //연기 애니메이션을 나타내는 smokeAnimate가 일어나지 않으면 gunSmoke가 smokeAnimate를 하지않게 합니다.
    //    if (![smokeAnimate isDone]) [gunSmoke stopAction:smokeAnimate];
    //
    //    //gunSmoke가 smokeAnimate를 수행하게 합니다.
    //    [gunSmoke runAction:smokeAnimate];
    for (CCSprite *sprite in catArray)
    {
        // birdArray 중의 객체 sprite를 isHitWithTarget:: 메소드를 써서 터치를 판별합니다.
        if ([self isHitWithTarget:sprite])
            
            // 터치가 되었을 시 birdisDead: 메소드를 수행합니다.
            [self birdHit:sprite];
        
    }
    for (CCSprite *sprite in itemArray)
    {
        // birdArray 중의 객체 sprite를 isHitWithTarget:: 메소드를 써서 터치를 판별합니다.
        if ([self isHitWithTarget:sprite])
            
            // 터치가 되었을 시 birdisDead: 메소드를 수행합니다.
            [self itemHit:sprite];
    }
    if(checkCombo == NO){
        lblCombo.visible = NO;
        gameCombo = 0;
        [self lifeLoss];
        [message showMessage:MISS_MESSAGE];
    }
    else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.wav"];
        
        
    }
    
    
    [lblCombo setString:[NSString stringWithFormat:@"COMBO %d!",gameCombo]];
    NSLog(@"%d",checkCombo);
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

//손가락을 화면에서 떼는 순간 호출되는 함수입니다.
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (BOOL)isHitWithTarget:(CCSprite *)target {
    
    // target과 touchPoint 간의 거리가 (target의 크기/2) 이면 터치한 것으로 판단하여 YES 값을 반환합니다.
    //if(ccpDistance(target.position, ccp(0, 160)) < target.contentSize.width /2) return YES;
    if(target.position.x < player.position.x + 100 && target.position.y < player.position.y+50 && target.position.x > player.position.x - 20) return YES;
    // 그렇지 않다면 NO 값을 반환합니다.
    return NO;
    
}
-(void)birdHit:(CCSprite*)bird{
    
    [self upCombo:bird];
    [bird stopAllActions];
    id hitMove = [CCMoveBy actionWithDuration:0.2f position:ccp(100, 200)];
    id hitRotate = [CCRotateBy actionWithDuration:0.5f angle:1080];
    id spwMove = [CCSpawn actions:hitMove,hitRotate, nil];
    id hitComplete = [CCCallFuncN actionWithTarget:self selector:@selector(birdisDead:)];
    
    id sqnHit = [CCSequence actions:spwMove, hitComplete, nil];
    
    [bird runAction:sqnHit];
    //    [lblCombo setString:[NSString stringWithFormat:@"%d",gameCombo]];
    
    //    [lblCombo setString:[NSString stringWithFormat:@"COMBO %d!",gameCombo]];
}

-(void)birdisDead:(CCSprite*)bird {
    
    //새가 사라질 때(정확히 터치 했을 때) 점수가 100점 증가
    
    // bird 행하는 모든 Action을 멈춥니다.
    
    [bird stopAllActions];
    
    // removeBird: 메소드를 담은 객체 tailComplete 만듭니다.
    id tailComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    [[SimpleAudioEngine sharedEngine] playEffect:@"meow.wav"];
    // tailAnimate,  tailComplete를 순차적으로 진행하는 객체 actionSeq를 만든 뒤,
    // bird가  actionSeq를 행하도록 실행시킵니다.
    //    id actionSeq = [CCSequence actions:tailAnimate, tailComplete, nil];
    [bird runAction:tailComplete];
}

-(void)removeBird:(CCSprite*)bird {
    // removeChild란 addChild 한 객체를 지워주는 매개변수입니다.
    // bird를 제거함으로서 메모리가 불필요하게 쌓이는 것을 막습니다.
    //    [lblScore setString:[NSString stringWithFormat:@"%d",gameScore]];
    [self removeChild:bird cleanup:YES];
    
}

- (void)itemHit:(CCSprite*)item{
    [self upCombo:item];
    [item stopAllActions];
    id hitMove = [CCMoveBy actionWithDuration:0.5f position:ccp(100, 200)];
    id hitComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeItem2:)];
    id hitRotate = [CCRotateBy actionWithDuration:0.5f angle:1080];
    id spwMove = [CCSpawn actions:hitMove,hitRotate, nil];
    id seqHit = [CCSequence actions:spwMove,hitComplete, nil];
    [item runAction:seqHit];
    //    [lblCombo setString:[NSString stringWithFormat:@"%d",gameCombo]];
}

-(void)removeItem:(CCSprite*)item {
    [item stopAllActions];
    if(life < 3){
        life++;
        ptLife.percentage = life *100 / MAX_LIFE_COUNT;
    }
    NSLog(@"life = %d",life);
    [lblCombo setString:[NSString stringWithFormat:@"COMBO %d!",gameCombo]];
    [self removeChild:item cleanup:YES];
}

-(void) removeItem2:(CCSprite*)item {
    [item stopAllActions];
    [self removeChild:item cleanup:YES];
    //새가 사라질 때(정확히 터치 했을 때) 점수가 100점 증가
    //    [lblScore setString:[NSString stringWithFormat:@"%d",gameScore]];
    [message showMessage:CORRECT_MESSAGE];
    // removeChild란 addChild 한 객체를 지워주는 매개변수입니다.
    // bird를 제거함으로서 메모리가 불필요하게 쌓이는 것을 막습니다.
}
-(void)upCombo:(CCSprite*) target{
    [message showMessage:CORRECT_MESSAGE];
    [lblCombo stopAllActions];
    if (![hitEffectAnimate isDone]) [hitEffect stopAction:hitEffectAnimate];
    [hitEffect setPosition:target.position];
    [hitEffect runAction:hitEffectAnimate];
    checkCombo = YES;
    gameScore = gameScore + 100 + (gameCombo * 10);
    gameCombo++;
    NSLog(@"combo : %d",gameCombo);
    [lblScore setString:[NSString stringWithFormat:@"SCORE:%d",gameScore]];
    lblCombo.visible = YES;
    lblCombo.scale = 3.0f;
    [lblCombo setString:[NSString stringWithFormat:@"COMBO %d!",gameCombo]];
    id lblFadeOut = [CCFadeOut actionWithDuration:1.0f];
    id lblScaleDown = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    id lblspw = [CCSpawn actions:lblFadeOut,lblScaleDown, nil];
    [lblCombo runAction:lblspw];
}
-(void)lifeLoss{
    [message showMessage:MISS_MESSAGE];
    life--;
    ptLife.percentage = life *100 / MAX_LIFE_COUNT;
    NSLog(@"Life : %d",life);
    if(life<=0){
        NSLog(@"Game Over");
        [self scheduleOnce:@selector(gameOver:) delay:1];
    }
    lblCombo.visible = NO;
    gameCombo = 0;
}
-(void)gameOver:(id) sender{
    if ( gameScore < 0) gameScore = 0;
    
    appDelegate.gameScore = gameScore;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer node] withColor:ccWHITE]];
    
}
//-(void)hitTest{
//    CCSprite *test1 = [CCSprite spriteWithFile:@"credit.png"];
//    test1.scale = 0.1;
//    
//    // bird 스프라이트의 위치를 지정합니다.
//    [test1 setPosition:ccp(player.position.x + 100, 140)];
//    
//    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
//    [self addChild:test1 z:5];
//    
//    CCSprite *test2 = [CCSprite spriteWithFile:@"credit.png"];
//    test2.scale=0.1;
//    // bird 스프라이트의 위치를 지정합니다.
//    [test2 setPosition:ccp(player.position.x - 20, 140)];
//    
//    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
//    [self addChild:test2 z:5];
//    
//}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}@end
