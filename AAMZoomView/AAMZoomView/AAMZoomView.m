//
//  AAMZoomView.m
//  AAMZoomView
//
//  Created by 深津 貴之 on 12/04/14.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import "AAMZoomView.h"

@implementation AAMZoomView{
    NSMutableArray *activeTouches;
}

@synthesize containerView;
@synthesize contentView;
@synthesize contentScale;
@synthesize contentTranslationX;
@synthesize contentTranslationY;
@synthesize contentRotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup{
    self.multipleTouchEnabled = YES;
    
    contentScale = 1.0f;
    contentTranslationX = 0.f;
    contentTranslationY = 0.f;
    contentRotation = 0.0f;
    
    activeTouches = [[NSMutableArray alloc]initWithCapacity:2];
    
    containerView = [[UIView alloc]initWithFrame:self.bounds];
    containerView.multipleTouchEnabled = YES;
    [self addSubview:containerView];
}


-(void)layoutSubviews{
    float w = self.bounds.size.width;
    float h = self.bounds.size.height;
    containerView.bounds = self.bounds;
    containerView.center = CGPointMake(w*0.5, h*0.5);
}



#pragma mark - Transformation

-(void)scaleToAspectFit:(BOOL)animated{
    float cw = containerView.bounds.size.width;
    float ch = containerView.bounds.size.height;
    float w = contentView.bounds.size.width;
    float h = contentView.bounds.size.height;
    
    float ratioW = cw / w;
    float ratioH = ch / h;
    float s;
    if(ratioW<ratioH){
        s = ratioW;
    }else{
        s = ratioH;
    }
    
    contentTranslationX = 0.0;
    contentTranslationY = 0.0;
    contentRotation = 0.0;
    contentScale = s;
    
    if(animated){
        [UIView beginAnimations:nil context:nil];
        [self updateTransform];
        [UIView commitAnimations];
    }else{
        [self updateTransform];
    }
}

-(void)scaleToAspectFill:(BOOL)animated{
    float cw = containerView.bounds.size.width;
    float ch = containerView.bounds.size.height;
    float w = contentView.bounds.size.width;
    float h = contentView.bounds.size.height;
    
    float ratioW = cw / w;
    float ratioH = ch / h;
    float s;
    if(ratioW<ratioH){
        s = ratioH;
    }else{
        s = ratioW;
    }
    
    contentTranslationX = 0.0;
    contentTranslationY = 0.0;
    contentRotation = 0.0;
    contentScale = s;
    
    if(animated){
        [UIView beginAnimations:nil context:nil];
        [self updateTransform];
        [UIView commitAnimations];
    }else{
        [self updateTransform];
    }
}

-(void)updateTransform{
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, contentTranslationX, contentTranslationY);
    t = CGAffineTransformRotate(t, contentRotation);
    t = CGAffineTransformScale(t, contentScale, contentScale);
    contentView.transform = t;
}


#pragma mark - Getter / Setter

-(void)setContentScale:(float)val{
    contentScale = val;
    [self updateTransform];
}

-(void)setContentRotation:(float)val{
    contentRotation = val;
    [self updateTransform];
}

-(void)setContentTranslationX:(float)val{
    contentTranslationX = val;
    [self updateTransform];
}

-(void)setContentTranslationY:(float)val{
    contentTranslationY = val;
    [self updateTransform];
}

-(void)setContentView:(UIView *)view{
    contentView = view;
    contentView.center = CGPointMake(containerView.bounds.size.width*0.5, containerView.bounds.size.height*0.5);
    [self updateTransform];
}


#pragma mark - Touches Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        [activeTouches addObject:touch];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if([activeTouches count]>2){
        return;
    }
    float dx = 0.0;
    float dy = 0.0;
    float dr = 0.0;
    float ds = 1.0;
    
    if([activeTouches count]==1){
        UITouch *t0 = [activeTouches objectAtIndex:0];
        CGPoint crntPt = [t0 locationInView:self];
        CGPoint prevPt = [t0 previousLocationInView:self];
        dx = crntPt.x - prevPt.x;
        dy = crntPt.y - prevPt.y;
        dr = 0;
        ds = 1.0;
    }else if([activeTouches count]==2){
        UITouch *t0 = [activeTouches objectAtIndex:0];
        UITouch *t1 = [activeTouches objectAtIndex:1];
        CGPoint crntPt0 = [t0 locationInView:self];
        CGPoint prevPt0 = [t0 previousLocationInView:self];
        CGPoint crntPt1 = [t1 locationInView:self];
        CGPoint prevPt1 = [t1 previousLocationInView:self];
        
        //Translation
        CGPoint crntPt = CGPointMake((crntPt0.x+crntPt1.x) * 0.5f, (crntPt0.y+crntPt1.y)*0.5f);
        CGPoint prevPt = CGPointMake((prevPt0.x+prevPt1.x) * 0.5f, (prevPt0.y+prevPt1.y)*0.5f);
        dx = crntPt.x - prevPt.x;
        dy = crntPt.y - prevPt.y;
        
        //Rotation
        float prevRad = atan2f(prevPt0.y-prevPt1.y, prevPt0.x-prevPt1.x);
        float crntRad = atan2f(crntPt0.y-crntPt1.y, crntPt0.x-crntPt1.x);
        dr = crntRad - prevRad;
        
        //Scale)
        float prevDist = sqrt((prevPt0.x-prevPt1.x)*(prevPt0.x-prevPt1.x)+(prevPt0.y-prevPt1.y)*(prevPt0.y-prevPt1.y));
        float crntDist = sqrt((crntPt0.x-crntPt1.x)*(crntPt0.x-crntPt1.x)+(crntPt0.y-crntPt1.y)*(crntPt0.y-crntPt1.y));
        ds = crntDist / prevDist;
    }
    
    contentTranslationX += dx;
    contentTranslationY += dy;
    contentRotation += dr;
    contentScale *= ds;
    
    [self updateTransform];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        [activeTouches removeObject:touch];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        [activeTouches removeObject:touch];
    }
}

@end
