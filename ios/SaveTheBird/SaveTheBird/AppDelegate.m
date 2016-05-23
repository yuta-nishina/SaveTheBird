//
//  AppDelegate.m
//  SaveTheBird
//
//  Created by ATGS_Mac on 2016/05/13.
//  Copyright © 2016年 ATGS. All rights reserved.
//

#import "AppDelegate.h"
#import "Charactor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // CoreDataに初期データが入っていない場合、初期データを挿入する  --------------------------------------
    NSMutableArray * charactors = [self getCharactors];

    if (charactors.count == 0) {
        if ([self initMasterData] == 0) {
            NSError * error = nil;
            NSLog(@"initMasterData: failed, %@", [error localizedDescription]);
            return nil;
        }
    }
    
    // BGMの再生準備  -----------------------------------------------------------------------------
    NSError *error = nil;
    // 再生する audio ファイルのパスを取得
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
    // パスから、再生するURLを作成する
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    // audio を再生するプレイヤーを作成する
    self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    // 繰り返しの回数を指定
    self.bgmPlayer.numberOfLoops = -1; // 無限ループ(-1)
    // エラーが起きたとき
    if (error != nil) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    // 自分自身をデリゲートに設定
    [self.bgmPlayer setDelegate:self];
    

    
    return YES;
}

- (NSMutableArray *)getCharactors{
    
    // データ取得用のオブジェクトであるFetchオブジェクトを作成
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Charactor class])];
    
    // Sort条件を設定（No順で昇順）
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"no" ascending:YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // manageObjectContextからデータを取得
    NSManagedObjectContext * context = [[AppDelegate alloc]init].managedObjectContext;
    NSArray * results = [context executeFetchRequest:fetchRequest error:nil];
    
    
    NSMutableArray * charactors = [NSMutableArray array];
    for (Charactor * charactor in results) {
        [charactors addObject:charactor];
    }
    
    return charactors;
}

- (NSUInteger)initMasterData {
    // プロパティリストを読み込んで初期データをセットする
    NSString * path = [[NSBundle mainBundle]pathForResource:@"MasterData" ofType:@"plist"];
    NSDictionary * mastersDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * mastersList = mastersDictionary[@"charactor"];
    if (mastersList == nil) {
        // エラー
        NSLog(@"Initialize Data file not found");
        return 0;
    }
    // 管理対象オブジェクトコンテキストを取得
    NSManagedObjectContext * context;
    context = self.managedObjectContext;
    
    int i = 0;
    for (i = 0; i < [mastersList count]; i++) {
        NSDictionary * masterItem = [mastersList objectAtIndex:i];
        // Mindを作成
        Charactor * charactor;
        charactor = [NSEntityDescription insertNewObjectForEntityForName:@"Charactor" inManagedObjectContext:context];
        charactor.no = [masterItem objectForKey:@"no"];
        charactor.name = [masterItem objectForKey:@"name"];
        charactor.detail = [masterItem objectForKey:@"detail"];
        charactor.image_stand = [masterItem objectForKey:@"image_stand"];
        
        // CoreDataへデータを保存
        NSError * error;
        if (![context save:&error]) {
            NSLog(@"error = %@", error);
        } else {
            NSLog(@"成功");
        }
        
        [self saveContext];
    }
    return i;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // BGMの再生をストップする
    if (self.bgmPlayer.playing) {
        [self.bgmPlayer stop];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // BGMの再生をスタートする
    if (!self.bgmPlayer.playing) {
        [self.bgmPlayer play];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "test.nisina.TestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SaveTheBird" withExtension:@"momd"];
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *keys = [dic allKeys];
    NSArray *vals = [dic allValues];
    for (int i=0; i<[keys count]; i++) {
        NSLog(@"キー：%@ 値：%@",[keys objectAtIndex:i],[vals objectAtIndex:i]);
    }
    
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SaveTheBird.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
