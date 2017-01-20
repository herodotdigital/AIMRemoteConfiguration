//
//  ViewController.m
//  RemoteConfiguration
//
//  Created by Maciej Gad on 18.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+list.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *quotation;
@property (weak, nonatomic) IBOutlet UILabel *citation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.quotation.textColor = [UIColor textColor];
    self.citation.textColor = [UIColor textColor];
}


@end
