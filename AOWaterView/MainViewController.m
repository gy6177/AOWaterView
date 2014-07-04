//
//  MainViewController.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MainViewController.h"
#import "ASIFormDataRequest.h"
#import "DataInfo.h"
#import "SBJSON.h"

@interface MainViewController ()
{
    int  pageindex;
}

@property (nonatomic, retain) NSMutableArray * arrayImage;

@end

@implementation MainViewController
@synthesize aoView;
@synthesize arrayImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayImage = [[NSMutableArray alloc]init];
    pageindex = 0;
    NSString * urlStr = @"http://www.duitang.com/album/1733789/masn/p/";
    urlStr = [urlStr stringByAppendingFormat:@"%d/24/",pageindex];
    //请求数据
    [self requestData:urlStr];

//    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
//    NSMutableArray *dataArray = [DataInfo getDateArray];

    [self createHeaderView];
    //[self setFooterView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    // Do any additional setup after loading the view from its nib.
}
//请求数据
-(void)requestData:(NSString *)urlStr
{
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setDidFailSelector:@selector(uploadFailed:)];
    [request setDidFinishSelector:@selector(uploadFinished:)];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    SBJSON * json = [[SBJSON alloc]init];
    NSDictionary * dict = [json objectWithString:theRequest.responseString];
    //    NSDictionary * information = [json objectWithString:theRequest.responseString];
    //    NSLog(@"dict  %@",dict);
    if (dict) {
        NSDictionary * dataDict = [dict objectForKey:@"data"];
        NSArray * blogsArray = [dataDict objectForKey:@"blogs"];
        //        NSLog(@"blogsArray  %@",blogsArray);
        for (int i=0; i<[blogsArray count]; i++) {
            NSDictionary *dataD = [blogsArray objectAtIndex:i];
            if (dataD) {
                DataInfo *dataInfo = [[DataInfo alloc]initWithDictionary:dataD];
                [arrayImage addObject:dataInfo];
            }
        }
        NSLog(@"arrayImage %@",arrayImage);
    }
    
    self.aoView = [[AOWaterView alloc]initWithDataArray:arrayImage];
    self.aoView.delegate=self;
    [self.view addSubview:self.aoView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.aoView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.aoView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }

	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
//    pageindex = 1;
//    NSString * urlStr = @"http://www.duitang.com/album/1733789/masn/p/";
//    urlStr = [urlStr stringByAppendingFormat:@"%d/24/",pageindex];
//    [arrayImage removeAllObjects];
//
//    [self requestData:urlStr];
    
    [self.aoView refreshView:arrayImage];
    [self testFinishedLoadData];

}
//加载调用的方法
-(void)getNextPageView{
//    [self removeFooterView];
//    pageindex = 2;
//    NSString * urlStr = @"http://www.duitang.com/album/1733789/masn/p/";
//    urlStr = [urlStr stringByAppendingFormat:@"%d/24/",pageindex];
//    [self requestData:urlStr];
//    NSMutableArray *testData = [[NSMutableArray alloc]init];
//    for (int i=0; i<9; i++) {
//        [testData addObject:[dataArray objectAtIndex:i]];
//    }
    [self.aoView getNextPage:arrayImage];
    [self testFinishedLoadData];
   
}-(void)testFinishedLoadData{

    [self finishReloadingData];
    [self setFooterView];
}

@end
