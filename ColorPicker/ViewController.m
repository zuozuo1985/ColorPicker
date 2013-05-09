//
//  ViewController.m
//  ColorPicker
//
//  Created by user on 13-3-13.
//  Copyright (c) 2013年 Eastech. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "TIBLECBKeyfob.h"

@interface ViewController ()<TIBLECBKeyfobDelegate>{
    IBOutlet UILabel *redLabel;
    IBOutlet UILabel *greenLabel;
    IBOutlet UILabel *blueLabel;
    IBOutlet UIImageView *colorImageV;
    IBOutlet UIImageView *colorView;
    //IBOutlet UIActivityIndicatorView *TIBLEUISpinner;
    
     TIBLECBKeyfob *t; //TI keyfob class (private)
}
@property(nonatomic,retain)UILabel *redLabel;
@property(nonatomic,retain)UILabel *greenLabel;
@property(nonatomic,retain)UILabel *blueLabel;
@property(nonatomic,retain)UILabel *scanLabel ;
@property(nonatomic,retain)UIImageView *ringImage;
@property(nonatomic,retain)UIImageView *colorView;
@property(nonatomic,retain)UIImageView *colorImageV;

@property (retain, nonatomic)UIActivityIndicatorView *TIBLEUISpinner;

-(IBAction)imagePicker:(id)sender;

@end

@implementation ViewController

@synthesize redLabel,greenLabel,blueLabel;
@synthesize ringImage;
@synthesize colorView;
@synthesize colorImageV;
@synthesize TIBLEUISpinner;
@synthesize scanLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    t.delegate = self;
    
    //init color view
    colorImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 335)];
    [colorImageV setImage:[UIImage imageNamed:@"colorPicker.png"]];
    [self.view addSubview:colorImageV];
    
    //增加圆环图示
    ringImage = [[UIImageView alloc]initWithFrame:CGRectMake(155, 205, 10, 10)];
    [ringImage setImage:[UIImage imageNamed:@"ring.png"]];
    [self.view addSubview:ringImage];
    
    //抓取color
    [self getPixelColorAtLocation:CGPointMake(160, 210-44) fromImage:colorImageV.image];
    
    //增加一个小菊花
    TIBLEUISpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(155, 205, 10, 10)];
    [TIBLEUISpinner setColor:[UIColor blackColor]];
    [self.view addSubview:TIBLEUISpinner];
    //[TIBLEUISpinner startAnimating];
    //[TIBLEUISpinner stopAnimating];
    
    [self TIBLEUIScanForPeripheralsButton:nil];
    
    scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 225, 150, 30)];
    [scanLabel setBackgroundColor:[UIColor clearColor]];
    scanLabel.text = @"Scanning BT LED";
    [self.view addSubview:scanLabel];
    //[self.scanLabel setHidden:YES];
    
    //添加一个上面image下面title的Button
    /*UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 400, 40, 35)];
    [myButton setImage:[UIImage imageNamed:@"bl222.png"] forState:UIControlStateNormal];
    [myButton setImageEdgeInsets:UIEdgeInsetsMake(0,(myButton.frame.size.width-52),17,0)];
    [myButton setTitle:@"test" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [myButton setTitleEdgeInsets: UIEdgeInsetsMake(17,(myButton.frame.size.width-78),0,22)];
    [self.view addSubview:myButton];*/
    
    /*UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 400, 50, 44)];
    [myButton setImage:[UIImage imageNamed:@"bl222.png"] forState:UIControlStateNormal];
    [myButton setImageEdgeInsets:UIEdgeInsetsMake(0,10,20,0)];
    [myButton setTitle:@"test" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [myButton setTitleEdgeInsets: UIEdgeInsetsMake(20,-10,0,0)];
    [self.view addSubview:myButton];*/
    
    //设置背景
    /*UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 400, 73, 44)];
    
    [myButton setBackgroundImage:[UIImage imageNamed:@"bl.png"] forState:UIControlStateNormal];
    [myButton setImageEdgeInsets: UIEdgeInsetsMake(0,0,22,0)];
    
    [myButton setTitle:@"test" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [myButton setTitleEdgeInsets: UIEdgeInsetsMake(22,10,0,10)];
    
    [self.view addSubview:myButton];*/
    
}

//查找bt4.0设备
- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender {
    if (t.activePeripheral) {
        if(t.activePeripheral.isConnected) {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
           // [TIBLEUIConnBtn setTitle:@"Scan and connect to KeyFob" forState:UIControlStateNormal];
            t.activePeripheral = nil;
        }
    } else {
        if (t.peripherals) t.peripherals = nil;
        [t findBLEPeripherals:5];
        //        [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
        [TIBLEUISpinner startAnimating];
        //[TIBLEUIConnBtn setTitle:@"Scanning.." forState:UIControlStateNormal];
    }
}

//向连接好的bt4.0模块发送数据
- (IBAction)TIBLEUISoundBuzzerButton:(id)sender {
    [t soundBuzzer:0x02 p:[t activePeripheral]]; //Sound buzzer with 0x02 as data value
}

//Method from TIBLECBKeyfobDelegate, called when keyfob has been found and all services have been discovered
-(void) keyfobReady {
    //[TIBLEUIConnBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
    // Start battery indicator timer, calls batteryIndicatorTimer method every 2 seconds
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(batteryIndicatorTimer:) userInfo:nil repeats:YES];
    [t enableAccelerometer:[t activePeripheral]];   // Enable accelerometer (if found)
    [t enableButtons:[t activePeripheral]];         // Enable button service (if found)
    [t enableTXPower:[t activePeripheral]];         // Enable TX power service (if found)
    [TIBLEUISpinner stopAnimating];
    [self.scanLabel setHidden:YES];
}

-(IBAction)returnTheInitImage:(id)sender{
    [colorImageV setImage:[UIImage imageNamed:@"colorPicker.png"]];
    ringImage.center = CGPointMake(160, 210);
    [self getPixelColorAtLocation:CGPointMake(160, 210-44) fromImage:colorImageV.image];
    
}


-(IBAction)imagePicker:(id)sender{
    UIImagePickerController *myPicker=[[UIImagePickerController alloc] init];
    myPicker.delegate = self;
	
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        //上面這一行主要是在判斷裝置是否支援此項功能
        myPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        myPicker.allowsEditing = YES;
        myPicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self presentModalViewController:myPicker animated:YES];
        [myPicker release];
        
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  
    NSLog(@"%f   %f",image.size.width,image.size.height);
    [colorImageV setImage:image];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self getPixelColorAtLocation:CGPointMake(160, 210-44) fromImage:colorImageV.image];
    ringImage.center = CGPointMake(160, 210);
    
}

#pragma mark touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self.view];
    
    if (point.y <379&&point.y>44) {
        
        CGPoint myPoint1 = CGPointMake(point.x*(colorImageV.image.size.width)/320, (point.y-44)*(colorImageV.image.size.height)/355);
        
	    //[self getPixelColorAtLocation:myPoint1 fromImage:[UIImage imageNamed:@"colorPicker2.png"]];
        [self getPixelColorAtLocation:myPoint1 fromImage:colorImageV.image];
        
         //移动选择ring到触摸的地方
        ringImage.center = point;
        
        [self TIBLEUISoundBuzzerButton:nil];//发送数据
    }else{
        /*[self.redLabel setText:@"0"];
        [self.greenLabel setText:@"0"];
        [self.blueLabel setText:@"0"];*/
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
    
    if (point.y <379&&point.y>44) {
        
        //CGPoint myPoint2 = CGPointMake(point.x, point.y-44);
         CGPoint myPoint2 = CGPointMake(point.x*(colorImageV.image.size.width)/320, (point.y-44)*(colorImageV.image.size.height)/355);
	    //[self getPixelColorAtLocation:myPoint2 fromImage:[UIImage imageNamed:@"colorPicker2.png"]];
        [self getPixelColorAtLocation:myPoint2 fromImage:colorImageV.image];
         //移动到这个地方
        ringImage.center = point;
    }else{
        /*[self.redLabel setText:@"0"];
        [self.greenLabel setText:@"0"];
        [self.blueLabel setText:@"0"];*/
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
    
    if (point.y <379&&point.y>44) {
        
        //CGPoint myPoint3 = CGPointMake(point.x, point.y-44);
         CGPoint myPoint3 = CGPointMake(point.x*(colorImageV.image.size.width)/320, (point.y-44)*(colorImageV.image.size.height)/355);
	    //[self getPixelColorAtLocation:myPoint3 fromImage:[UIImage imageNamed:@"colorPicker2.png"]];
        [self getPixelColorAtLocation:myPoint3 fromImage:colorImageV.image];
        
        //移动到这个地方
        ringImage.center = point;
    }else{
        /*[self.redLabel setText:@"0"];
        [self.greenLabel setText:@"0"];
        [self.blueLabel setText:@"0"];*/
    }
}


#pragma mark getPixelColor
//获取图片中单个点的颜色：
- (UIColor *) getPixelColorAtLocation:(CGPoint)point fromImage:(UIImage*) image{
    
    UIColor* color = nil;
    
    CGImageRef inImage = [image CGImage];
    
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    
    CGContextRef cgctx = CreateARGBBitmapContext(inImage, image.size);
    
    if (cgctx == NULL) {
        
        return nil; /* error */
        
    }
    
    
    
    size_t w = CGImageGetWidth(inImage);
    
    size_t h = CGImageGetHeight(inImage);
    
    CGRect rect = {{0,0},{w,h}};
    
    
    
    // Draw the image to the bitmap context. Once we draw, the memory
    
    // allocated for the context for rendering will then contain the
    
    // raw image data in the specified color space.
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    
    
    // Now we can get a pointer to the image data associated with the bitmap
    
    // context.
    
    unsigned char* data = CGBitmapContextGetData (cgctx);
    
    if (data != NULL) {
        
        //offset locates the pixel in the data from x,y.
        
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        
        //每个带alpha通道的位图上的点含有4个部分，alpha，red，green和blue ，范围0－255（8比特位图）
        
        int offset = 4*((w*round(point.y))+round(point.x));
        
        int alpha =  data[offset];
        
        int red = data[offset+1];
        
        int green = data[offset+2];
        
        int blue = data[offset+3];
        
        NSLog(@"set Color: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        
        //把颜色值在label上面显示
        [self.redLabel setText:[NSString stringWithFormat:@"%d",red]];
        [self.greenLabel setText:[NSString stringWithFormat:@"%d",green]];
        [self.blueLabel setText:[NSString stringWithFormat:@"%d",blue]];
        
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        
        [self.colorView setBackgroundColor:color];
        
        
    }
    
    
    // When finished, release the context
    
    CGContextRelease(cgctx);
    
    // Free image data memory for the context
    
    if (data) { free(data); }
    
    return color;
    
}

//上述函数中使用到的自定义函数CreateARGBBitmapContext 如下：

CGContextRef CreateARGBBitmapContext (CGImageRef inImage, CGSize size)

{
    
    CGContextRef    context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *          bitmapData;
    
    int             bitmapByteCount;
    
    int             bitmapBytesPerRow;
    
    
    size_t pixelsWide = size.width;
    
    size_t pixelsHigh = size.height;
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//查询官方文档关于此处的详细信息，记得用晚后要释放
    
    
    if (colorSpace == NULL)
        
    {
        
        fprintf(stderr, "Error allocating color space\n");
        
        return NULL;
        
    }
    
    
    // allocate the bitmap & create context
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
        
    {
        
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
        
    }
    
    
    context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8,
                                     
                                     bitmapBytesPerRow, colorSpace,
                                     
                                     kCGImageAlphaPremultipliedFirst);//创建带alpha通道的8比特位图
    
    if (context == NULL)
        
    {
        
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
        
    }
    
    
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
