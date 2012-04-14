//
//  ViewController.m
//  AAMZoomView
//
//  Created by 深津 貴之 on 12/04/14.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize zoomView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image"]];
    [self.zoomView.containerView addSubview:imgv];
    
    self.zoomView.contentView = imgv;
    [self.zoomView scaleToAspectFit:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    zoomView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //宿題。　回転後も位置関係を保持するにはどうすればいいでしょう？
    //回転時にViewのZoomView.containerViewのcenterあるいは、contentViewのCenterを修正すれば
}

-(IBAction)aspectFit:(id)sender{
    [self.zoomView scaleToAspectFit:YES];
}

-(IBAction)aspectFill:(id)sender{
    [self.zoomView scaleToAspectFill:YES];
}


@end
