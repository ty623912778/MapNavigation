//
//  ViewController.m
//  MapNavigation
//
//  Created by mac on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import<MapKit/MapKit.h>
#import "MBProgressHUD+MJ.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *startField;//起点
@property (weak, nonatomic) IBOutlet UITextField *endField;//终点
@property (nonatomic, strong)CLGeocoder *geocoder;//地理编码

- (IBAction)startNavigation;//开始导航

@end

@implementation ViewController
#warning geocoder懒加载
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (IBAction)startNavigation {
    
    //获取用户输入的起点终点
    NSString *startStr = self.startField.text;
    NSString *endStr = self.endField.text;
    
    if (startStr == nil || startStr.length == 0|| endStr == nil || endStr.length == 0 ) {
        [MBProgressHUD showError:@"请输入地址"];
        return;
    }
    
    //利用GEO对象进行地理编码获取地标对象
    //获取开始位置的地标
    [self.geocoder geocodeAddressString:startStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error != nil) {
            [MBProgressHUD showError:@"请输入地址"];
            return ;
        }
        //开始位置的地标
        CLPlacemark *startPlacemark = [placemarks firstObject];
        
        //获得结束位置的地标
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count == 0||error!=nil) {
                [MBProgressHUD showError:@"请输入地址"];
                return ;
            }
            CLPlacemark *endPlacemark = [placemarks firstObject];
            //获得地标后开始导航
            [self startNavigationWithStartPlacemark:startPlacemark endPlacemark:endPlacemark];
        }];
    }];
    

}
//利用地标位置开始设置导航
- (void)startNavigationWithStartPlacemark:(CLPlacemark *)startPlacemark endPlacemark:(CLPlacemark *)endPlacemark{
    //创建起点 终点
    MKPlacemark * startMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:startPlacemark];
    
    MKPlacemark * endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endPlacemark];
    
    //设置起点终点位置
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMKPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
    
    //起点终点数组
    NSArray *items = @[startItem,endItem];
    
    //设置地图附加参数
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //导航模式（驾车，步行）
    dicM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    //地图显示的模式
    dicM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
    
    
    //调用MKMapItem的open方法调用系统自带地图的导航
    //Items:告诉系统地图从哪到哪
    //launchOptions:启动地图APP参数(导航的模式/是否需要先交通状况/地图的模式/..)
    [MKMapItem openMapsWithItems:items launchOptions:dicM];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
