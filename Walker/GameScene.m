//
//  GameScene.m
//  Walker
//
//  Created by Explocial 6 on 07/10/2014.
//  Copyright (c) 2014 Explocial 6. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    /*
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];*/
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"restartBtn.png"];
        fireNode.position = CGPointMake(290, self.frame.size.height - 40);
        fireNode.size = CGSizeMake(30, 30);
        fireNode.name = @"restartButtonNode";//how the node is identified later
        fireNode.zPosition = 1.0;
        [self addChild:fireNode];
        
        self.physicsWorld.gravity = CGVectorMake( 0.0, -2.0 );
        
        SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"Spaceship"];
        birdTexture1.filteringMode = SKTextureFilteringNearest;
        
        self.bird = [SKSpriteNode spriteNodeWithTexture:birdTexture1];
        [self.bird setScale:.1];
        self.bird.position = CGPointMake(self.frame.size.width / 4, self.frame.size.height / 4);
        
        self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.height / 2];
        self.bird.physicsBody.dynamic = YES;
        self.bird.physicsBody.allowsRotation = NO;
        
        [self addChild:self.bird];
        
        /*
         SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"Bird1"];
         birdTexture1.filteringMode = SKTextureFilteringNearest;
         SKTexture* birdTexture2 = [SKTexture textureWithImageNamed:@"Bird2"];
         birdTexture2.filteringMode = SKTextureFilteringNearest;
         
         SKAction* flap = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTexture1, birdTexture2] timePerFrame:0.2]];
         
         _bird = [SKSpriteNode spriteNodeWithTexture:birdTexture1];
         [_bird setScale:2.0];
         _bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame));
         [_bird runAction:flap];*/
        
        
        self.skyColor = [SKColor colorWithRed:113.0/255.0 green:197.0/255.0 blue:207.0/255.0 alpha:1.0];
        [self setBackgroundColor:self.skyColor];
        
        
        SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"Ground"];
        groundTexture.filteringMode = SKTextureFilteringNearest;
        
        SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.02 * groundTexture.size.width*2];
        SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
        SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
        
        for( int i = 0; i < self.frame.size.width / groundTexture.size.width; ++i ) {
            // Create the sprite
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
            [sprite setScale:2.0];
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
            [sprite runAction:moveGroundSpritesForever];
            [self addChild:sprite];
        }
        
        // Create skyline
        
        SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Skyline"];
        skylineTexture.filteringMode = SKTextureFilteringNearest;
        
        
        SKNode* dummy = [SKNode node];
        dummy.position = CGPointMake(0, skylineTexture.size.height*2);
        dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, skylineTexture.size.height * 2)];
        dummy.physicsBody.dynamic = NO;
        [self addChild:dummy];
        
        
        SKAction* moveSkylineSprite = [SKAction moveByX:-skylineTexture.size.width*2 y:0 duration:0.1 * skylineTexture.size.width*2];
        SKAction* resetSkylineSprite = [SKAction moveByX:skylineTexture.size.width*2 y:0 duration:0];
        SKAction* moveSkylineSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkylineSprite, resetSkylineSprite]]];
        
        for( int i = 0; i < self.frame.size.width / skylineTexture.size.width; ++i ) {
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
            [sprite setScale:2.0];
            sprite.zPosition = -20;
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2 + groundTexture.size.height * 2);
            [sprite runAction:moveSkylineSpritesForever];
            [self addChild:sprite];
        }
        
        
        
        
        // Create pipes
        
        self.pipeTexture1 = [SKTexture textureWithImageNamed:@"Pipe1"];
        self.pipeTexture1.filteringMode = SKTextureFilteringNearest;
        
        /*
        CGFloat y = arc4random() % (NSInteger)( self.frame.size.height / 2 );
        
        SKSpriteNode* pipe1 = [SKSpriteNode spriteNodeWithTexture:self.pipeTexture1];
        [pipe1 setScale:2];
        pipe1.position = CGPointMake( self.frame.size.width + self.pipeTexture1.size.width * 2, y + kVerticalPipeGap);
        pipe1.zPosition = -10;
        pipe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe1.size];
        pipe1.physicsBody.dynamic = NO;
        [self addChild:pipe1];
        
        SKAction* movePipes = [SKAction repeatActionForever:[SKAction moveByX:-1 y:0 duration:0.02]];
        [pipe1 runAction:movePipes];*/
        CGFloat distanceToMove = self.frame.size.width + 2 * self.pipeTexture1.size.width;
        SKAction* movePipes = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
        SKAction* removePipes = [SKAction removeFromParent];
        self.moveAndRemovePipes = [SKAction sequence:@[movePipes, removePipes]];
        
        
        
        SKAction* spawn = [SKAction performSelector:@selector(spawnPipes) onTarget:self];
        SKAction* delay = [SKAction waitForDuration:2.0];
        SKAction* spawnThenDelay = [SKAction sequence:@[spawn, delay]];
        SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
        [self runAction:spawnThenDelayForever];
        
        
        self.pipes = [SKNode node];
        [self addChild:self.pipes];
        
    }
    return self;
}


-(void)spawnPipes {
    
    CGFloat y = arc4random() % (NSInteger)( self.frame.size.height / 3 );
    
    SKSpriteNode* pipe1 = [SKSpriteNode spriteNodeWithTexture:self.pipeTexture1];
    [pipe1 setScale:2];
    pipe1.position = CGPointMake( self.frame.size.width + self.pipeTexture1.size.width, y );
    pipe1.zPosition = - 10;
    pipe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe1.size];
    pipe1.physicsBody.dynamic = NO;
    
    [pipe1 runAction:self.moveAndRemovePipes];
    
    [self.pipes addChild:pipe1];
}


-(void)resetScene {
    // Move bird to original position and reset velocity
    self.bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame));
    self.bird.physicsBody.velocity = CGVectorMake( 0, 0 );
    
    // Remove all existing pipes
    [self.pipes removeAllChildren];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
    
    UITouch *touch      = [touches anyObject];
    CGPoint location    = [touch locationInNode:self];
    SKNode *node        = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"restartButtonNode"]) {
        
        [self resetScene];
    }
    else{
        
        self.bird.physicsBody.velocity = CGVectorMake(0, 0);
        [self.bird.physicsBody applyImpulse:CGVectorMake(0, 8)];
    }
}


CGFloat clamp(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    self.bird.zRotation = clamp( -1, 0.5, self.bird.physicsBody.velocity.dy * (self.bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) );
}

@end
