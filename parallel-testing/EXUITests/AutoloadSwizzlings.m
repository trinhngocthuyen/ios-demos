//
//  AutoLoadSwizzling.m
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@implementation XCTestSuite (AutoloadSwizzlings)

+ (void)load {
  Method testClassSuitesForTestIdentifiers = class_getClassMethod(self, NSSelectorFromString(@"testClassSuitesForTestIdentifiers:skippingTestIdentifiers:randomNumberGenerator:"));
  Method hooked_testClassSuitesForTestIdentifiers = class_getClassMethod(self, @selector(hooked_testClassSuitesForTestIdentifiers:skippingTestIdentifiers:randomNumberGenerator:));
  method_exchangeImplementations(testClassSuitesForTestIdentifiers, hooked_testClassSuitesForTestIdentifiers);
}

+ (id)hooked_testClassSuitesForTestIdentifiers:(id)arg1 skippingTestIdentifiers:(id)arg2 randomNumberGenerator:(long long)arg3 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  XCTestSuite *suite = [XCTestSuite hooked_testClassSuitesForTestIdentifiers:arg1 skippingTestIdentifiers:arg2 randomNumberGenerator:arg3];
  for (id testIdentifier in arg1) {
    NSArray<NSString *> *components = [testIdentifier performSelector:NSSelectorFromString(@"components")];

    // Given the input (tokenized test) as "TestCaseA_testA1/testA1",
    // -> testIdentifier is XCTTestIdentifier(["TestCaseA", "testA1"])
    // -> components = ["TestCaseA_testA1", "testA1"]
    NSString *testCaseName = [components firstObject];
    NSArray *testCaseComps = [testCaseName componentsSeparatedByString:@"_"];
    NSString *testName = [testCaseComps lastObject];

    // Now, if the testCaseName was tokenized, we strip the token
    // and add the actual suite/test (TestCaseA/testA1) to this suite
    if ([testCaseComps count] > 1 && [[testCaseComps lastObject] isEqual:testName]) {
      NSString *detokenized = [NSString stringWithFormat:@"%@/%@", testCaseComps[0], testName];
      NSLog(@"--> Detokenized: %@", detokenized);
      XCTestSuite *actual = [XCTestSuite testSuiteForTestCaseWithName:detokenized];
      [suite addTest:actual];
    }
  }
  return suite;
#pragma clang diagnostic pop
}

@end
