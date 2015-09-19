//
//  ViewController.m
//  MoviePlaySample
//
//  Created by mineharu on 2015/09/19.
//  Copyright (c) 2015年 Mineharu. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // trimから始まるファイルを全部削除する。
        [self removeAllTmpTrimFiles];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*) kUTTypeMovie];
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr UUIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@", url.absoluteString);
    
    // 撮影したファイルを削除する。※ホントはどっかで使ってその後に。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:url.path]) {
        if ([fileManager removeItemAtURL:url error:&error]) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma makr self methods
- (void)removeAllTmpTrimFiles
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    // tmp配下をすべて取得
    NSArray *allFileName =[fileManager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    if (error) {
        return;
    }
    for (NSString *fileName in allFileName) {
        if ([fileName hasPrefix:@"trim."]) {
            // tirm.から始まるファイルがカメラロールから選択した動画の名前っぽいので全部削除
            // 撮影だとCapture~ってディレクトリ作ってたりする。
            NSString *removePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:removePath error:&error];
        }
    }
}

@end
