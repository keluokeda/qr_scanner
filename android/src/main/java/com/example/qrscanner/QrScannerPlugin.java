package com.example.qrscanner;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;

import java.io.ByteArrayOutputStream;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.reactivex.Observable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * QrScannerPlugin
 */
public class QrScannerPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "github.com/keluokeda/qr_scanner");
        QrScannerPlugin qrScannerPlugin = new QrScannerPlugin(registrar.activity());

        channel.setMethodCallHandler(qrScannerPlugin);

        registrar.addActivityResultListener(qrScannerPlugin);
    }

    private Result mResult;

    private Activity mActivity;

    private QrScannerPlugin(Activity activity) {
        mActivity = activity;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "scan":
                mResult = result;
                Intent intent = new Intent(mActivity, QRScanActivity.class);
                mActivity.startActivityForResult(intent, 100);
                break;
            case "createQRImageData":
                createQRImageData(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }


    @Override
    public boolean onActivityResult(int code, int resultCode, Intent intent) {
        if (code == 100) {
            if (resultCode == Activity.RESULT_OK) {
                String result = intent.getStringExtra(QRScanActivity.EXTRA_SCAN_RESULT);
                mResult.success(result);
            } else if (resultCode == Activity.RESULT_CANCELED) {
                mResult.success(null);
            } else if (resultCode == QRScanActivity.RESPONSE_GRANT_FAILED) {
                mResult.error("用户授权失败", "用户授权失败", null);
            } else {
                mResult.error("未知操作", "未知操作", null);
            }
        }
        return true;
    }


    private void createQRImageData(MethodCall call, final Result result) {
        final String content = call.argument("content");
        final int size = call.argument("size");
        Observable.just(content)
                .observeOn(Schedulers.io())
                .map(new Function<String, Bitmap>() {
                    @Override
                    public Bitmap apply(String s) throws Exception {
                        return QRCodeEncoder.syncEncodeQRCode(content, size);
                    }
                }).map(new Function<Bitmap, byte[]>() {
            @Override
            public byte[] apply(Bitmap bitmap) throws Exception {
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
                return byteArrayOutputStream.toByteArray();
            }
        }).subscribe(new Consumer<byte[]>() {
            @Override
            public void accept(byte[] bytes) throws Exception {
                result.success(bytes);
            }
        }, new Consumer<Throwable>() {
            @Override
            public void accept(Throwable throwable) throws Exception {
                result.error("", "failed", null);
            }
        });
    }
}
