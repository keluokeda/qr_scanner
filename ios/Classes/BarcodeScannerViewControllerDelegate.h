//
// Created by Matthew Smith on 11/7/17.
//

#import <Foundation/Foundation.h>

@class QQLBXScanViewController;

@protocol BarcodeScannerViewControllerDelegate <NSObject>

- (void)didScanBarcodeWithResult:(NSString *)result;
- (void)didFailWithErrorCode:(NSString *)errorCode;

@end
