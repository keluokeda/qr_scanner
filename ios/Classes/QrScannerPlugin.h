#import <Flutter/Flutter.h>
#import "BarcodeScannerViewControllerDelegate.h"

#import "StyleDIY.h"
@interface QrScannerPlugin : NSObject<FlutterPlugin,BarcodeScannerViewControllerDelegate>
@property(nonatomic, retain) FlutterResult result;
@property (nonatomic, assign) UIViewController *hostViewController;
@end
