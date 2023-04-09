//
//  AutoLoadSwizzling.m
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

#import <EXUITests-Swift.h>

@implementation XCTestSuite (AutoloadSwizzlings)

+ (void)load {
  [XCTestSuite loadSwizzlings];
}

@end
