//
//  AAMZoomView.h
//  AAMZoomView
//
//  Created by 深津 貴之 on 12/04/14.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAMZoomView : UIView

@property (readonly, nonatomic) UIView *containerView;
@property (retain, nonatomic) UIView *contentView;

@property (assign, nonatomic) float contentScale;
@property (assign, nonatomic) float contentRotation;
@property (assign, nonatomic) float contentTranslationX;
@property (assign, nonatomic) float contentTranslationY;

-(void)scaleToAspectFit:(BOOL)animated;
-(void)scaleToAspectFill:(BOOL)animated;

@end
