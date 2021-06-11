//
//  ViewController.m
//  simulatedMoving
//
//  Created by Sunyc on 2021/6/11.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property(nonatomic ,strong) CLLocationManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    
    [_manager requestAlwaysAuthorization];
//    [_manager requestWhenInUseAuthorization];
    
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 1.0;
    
    [_manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            NSLog(@"当前国家 - %@",placeMark.country);
            NSLog(@"当前城市 - %@",currentCity);
            NSLog(@"当前位置 - %@",placeMark.subLocality);
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);
            NSLog(@"具体地址 - %@",placeMark.name);
        }
    }];
}

@end
