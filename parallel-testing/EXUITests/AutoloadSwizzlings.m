//
//  AutoLoadSwizzling.m
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

#import <EXUITests-Swift.h>

void DumpObjcMethods(Class clz) {

  unsigned int methodCount = 0;
  Method *methods = class_copyMethodList(clz, &methodCount);

  printf("Found %d methods on '%s'\n", methodCount, class_getName(clz));

  for (unsigned int i = 0; i < methodCount; i++) {
    Method method = methods[i];

    printf("\t'%s' has method named '%s' of encoding '%s'\n",
           class_getName(clz),
           sel_getName(method_getName(method)),
           method_getTypeEncoding(method));

    /**
     *  Or do whatever you need here...
     */
  }

  free(methods);
}

@implementation XCTestSuite (AutoloadSwizzlings)

+ (void)load {
  [XCTestSuite loadSwizzlings];

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
    NSString *testCaseName = [components firstObject];
    NSArray *testCaseComps = [testCaseName componentsSeparatedByString:@"_"];
    NSString *testName = [testCaseComps lastObject];
    NSLog(@"--> testIdentifier: %@, testCaseName: %@, testName: %@", testIdentifier, testCaseName, testName);

    if ([testCaseComps count] > 1 && [[testCaseComps lastObject] isEqual:testName]) {
      NSString *detokenized = [NSString stringWithFormat:@"%@/%@", testCaseComps[0], testName];
      NSLog(@"--> Detected: detokenized: %@", detokenized);
      XCTestSuite *proxy = [XCTestSuite testSuiteForTestCaseWithName:detokenized];
      [suite addTest:proxy];
    }
  }
  return suite;
#pragma clang diagnostic pop
}

@end
