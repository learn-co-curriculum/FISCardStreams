//
//  FISBlogViewController.m
//  FISCardStreams
//
//  Created by Nelly Santoso on 4/6/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISBlogViewController.h"
#import "FISRSSFeedAPIClient.h"
@interface FISBlogViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *blogView;


@end

@implementation FISBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blogView.frame = CGRectMake(10, 10, 300, 400);
    
    FISRSSFeedAPIClient *rssFeed = [[FISRSSFeedAPIClient alloc]initWithBlogUrl:@"https://medium.com/@joemantey"];
    NSArray *blogFeedList = [rssFeed getBlogList];
////    NSLog(@"blog is %@", blogFeedList);
//    for (NSDictionary *blogData in blogFeedList) {
//        NSString *description = blogData[@"description"];
//        [myWebView loadHTMLString:description baseURL:[NSURL URLWithString:@"https://medium.com/@n3llee"]];
//        [self.view addSubview:myWebView];
//    }

    NSString *my_string = blogFeedList[2][@"summary"];

    
    [self.blogView loadHTMLString:my_string baseURL:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
