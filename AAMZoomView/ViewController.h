//
//  ViewController.h
//  AAMZoomView
//
//  Created by 深津 貴之 on 12/04/14.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAMZoomView.h"

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet AAMZoomView *zoomView;

-(IBAction)aspectFit:(id)sender;
-(IBAction)aspectFill:(id)sender;

@end
