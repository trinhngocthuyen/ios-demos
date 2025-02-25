#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import <SwiftTestingSupport/XCTestConfiguration.h>
#import <SwiftTestingSupport/XCTTestIdentifier.h>
#import <SwiftTestingSupport/XCTTestIdentifierSet.h>

@implementation XCTestConfiguration (Swizzlings)
+ (void)load {
  NSLog(@"-> Load XCTestConfiguration (Swizzlings)");
  Method m1 = class_getClassMethod(self, @selector(activeTestConfiguration));
  Method m2 = class_getClassMethod(self, @selector(hooked_activeTestConfiguration));
  if (m1 != nil && m2 != nil) {
    method_exchangeImplementations(m1, m2);
  } else {
    [NSException raise:@"Unexpected swizzlings" format:@"Either m1 or m2 is nil"];
  }
}

+ (id)hooked_activeTestConfiguration {
  XCTestConfiguration* res = [self hooked_activeTestConfiguration];
  NSMutableSet* swiftTestingIdentifiers = [NSMutableSet set];
  for (XCTTestIdentifier* identifier in res.testsToRun) {
    // Test identifiers suffixed with parentheses `()`, `(x:)` are recognized as swift-testing identifiers.
    // Therefore, we just need to add a swift-testing identifier to `testsToRun`.
    // If an identifier is added but there is no such a test function, no worries, it's gonna be skipped.
    if (![identifier.lastComponent hasSuffix:@")"]) {
      NSMutableArray* components = [NSMutableArray arrayWithArray:identifier.components];
      components[components.count - 1] = [NSString stringWithFormat:@"%@()", identifier.lastComponent];
      [swiftTestingIdentifiers addObject:[[XCTTestIdentifier alloc] initWithComponents:components argumentIDs:nil options:0]];
    }
  }
  [res setTestsToRun:[res.testsToRun setByAddingTestIdentifiersFromSet:swiftTestingIdentifiers]];
  return res;
}
@end
