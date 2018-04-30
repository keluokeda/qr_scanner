#import "QrScannerPlugin.h"
//#import "BarcodeScannerViewController.h"
#import "QQLBXScanViewController.h"

@implementation QrScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"github.com/keluokeda/qr_scanner"
                                     binaryMessenger:[registrar messenger]];
    
    
    QrScannerPlugin* instance = [[QrScannerPlugin alloc] init];
    instance.hostViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    //    NSLog(@"");
    if ([@"scan" isEqualToString:call.method]) {
        self.result = result;
        [self showBarcodeView];
    } else if([@"createQRImageData" isEqualToString:call.method]){
        NSDictionary *arguments = call.arguments;
        NSString *content = arguments[@"content"];
        int  size = arguments[@"size"];
        [self createQrImageData:content size:size result:result];
    } else{
        result(FlutterMethodNotImplemented);
    }
}

-(void) createQrImageData:(NSString *)content size: (int) size result: (FlutterResult)result{
    UIImage *image =  [LBXScanNative createQRWithString:content QRSize:CGSizeMake(size, size)];
    
    NSData *data = UIImagePNGRepresentation(image);
    
    result([FlutterStandardTypedData typedDataWithBytes:data]);
}

- (void)showBarcodeView {
    
    QQLBXScanViewController *controller = [QQLBXScanViewController new];
    
    
    controller.style = [StyleDIY qqStyle];
    controller.scanDelegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.hostViewController presentViewController:navigationController animated:NO completion:nil];
}

-(void) didScanBarcodeWithResult:(NSString *)result {
    if (self.result) {
        self.result(result);
    }
}

- (void)didFailWithErrorCode:(NSString *)errorCode {
    if (self.result){
        self.result([FlutterError errorWithCode:errorCode
                                        message:errorCode
                                        details:nil]);
    }
}

@end
