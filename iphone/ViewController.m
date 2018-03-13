//
//  ViewController.m
//  iphone
//
//  Created by gcy on 2017/12/26.
//

#import "ViewController.h"
#import "FMDB.h" 
@interface ViewController ()
- (IBAction)insert:(id)sender;
@property(nonatomic,strong) FMDatabaseQueue * queue;
@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,assign)long long chatID;
@end

@implementation ViewController
-(void)enterBg{
    
    NSLog(@"akak enterbg:%@",@([UIApplication sharedApplication].backgroundTimeRemaining));
    __block UIBackgroundTaskIdentifier bgId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"akak beginBackgroundTaskWithExpirationHandler");
        [[UIApplication sharedApplication] endBackgroundTask:bgId];
        
        bgId = UIBackgroundTaskInvalid;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBg) name:UIApplicationDidEnterBackgroundNotification object:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbFile = [documentDirectory stringByAppendingPathComponent:@"1.db"];
    NSError*err;bool result;
   
    NSLog(@"dbFile:%@",dbFile);
    FMDatabaseQueue * queue1 = [[FMDatabaseQueue alloc]initWithPath:dbFile];
    self.queue=queue1;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    result=[[NSFileManager defaultManager] setAttributes:attributes
                                            ofItemAtPath:dbFile
                                                   error:&err];
    
    NSDictionary *dic = [[NSFileManager defaultManager]attributesOfItemAtPath:dbFile error:&err];
    NSLog(@"%@",dic[NSFileProtectionKey]);//NSFileProtectionComplete
    
}

- (IBAction)insert:(id)sender {
    /*
     等待一段时间后，数据库异常：IO错误，随后数据库损坏
     解决办法：
     FMDatabaseQueue.m：- (instancetype)initWithPath:(NSString*)aPath {
     [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION];
     }
     或者使用SQLITE_OPEN_FILEPROTECTION_NONE
     */
    
    
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *sql1 =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Chat_%lld(\
                             RemindPersons     Text\
                             );",self.chatID];
            
            BOOL ret = [db executeUpdate:sql1];
            if (ret) {
                for ( int i=0; i<1000000; i++) {
                    
                    NSString *sql =[NSString stringWithFormat:@"INSERT OR REPLACE INTO  Chat_%lld (RemindPersons) VALUES (?);",self.chatID] ;
                    
                    NSArray *paramets=[NSArray arrayWithObjects:@"123",nil];
                  
                    ret =[db executeUpdate:sql withArgumentsInArray:paramets];
                    NSLog(@"%@:%@",@(i),@(ret));
                }
            }
        }];
//    });
 
}


@end
