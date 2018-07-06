//
//  ViewController.m
//  ProxyReaderApp
//
//  Created by Hani on 10/04/18.
//  Copyright © 2018 Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize randLabel1,randLabel2,randLabel3,randLabel4;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    //Manual Proxy Details
    const NSString* proxyStr = (const NSString*)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesHTTPProxy);
    //Auto Config Proxy Details
    //const NSString* proxyStr2 = (const NSString*)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesProxyAutoConfigURLString);

    //Auto Config Proxy Details
    NSString* proxyStr2 = ( NSString*)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesProxyAutoConfigURLString);
    // Return something similar to http://65.74.159.186:45671/pacfile?device=f85d2f54d07300a602eddb287c9b13643b7f9d3e
    // proxyStr2=@"http://194.165.190.152:45671/pacfile?device=507e789aea90d0d72304cfd0b4445661c642be81";
    if (proxyStr2 != nil)
    {
        NSLog(@"Proxy %@", proxyStr2);
        // Create an url with the proxy pac
        NSURL *url = [NSURL URLWithString:proxyStr2];
        if (url != nil)
        {
            NSString* urlPath = [url path];
            // Url path: /pacfile
            NSLog(@"Url %@", urlPath);
            NSError* error;

            // !!!!
            // Go fetch the content the url, it seems to crash here.
            NSString *content = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];

            if (content == nil)
            {
                NSLog(@"StringWithContentsOfUrl Error: %@", error);
            }

            if (content != nil)
            {
                NSLog(@"PAC content: %@", content);

                // Parsing of the pac file
                NSUInteger firstMatch = [content rangeOfString:@"PROXY "].location + 6;
                NSUInteger secondMatch = [content rangeOfString:@"\"" options:0 range:NSMakeRange(firstMatch , [content length] - firstMatch)].location;

                if (firstMatch < 10000 && secondMatch < 10000 && firstMatch > 0 && secondMatch > 0)
                {
                    self.randLabel3.text=[NSString stringWithFormat: @"First match and second match: %tu %tu", firstMatch, secondMatch];
                    /*
                     NSRange range = NSMakeRange(firstMatch, secondMatch - firstMatch);

                     NSString* proxyAddress = [content substringWithRange:range];
                     if (proxyAddress != nil)
                     {
                     NSLog(@"Address: %@", proxyAddress);
                     //UnitySendMessage("NativeMessageHandler", "OnProxyAddress", [proxyAddress UTF8String]);
                     }
                     */
                }
            }
        }
    }
    
    //Auto Config Alt Proxy Details
    const NSString* proxyStr3 = (const NSString*)CFDictionaryGetValue(dicRef, (const void*)kCFProxyAutoConfigurationURLKey);
    
    NSString *urlstring = [NSString stringWithFormat:@"http://www.apple.com"];
    NSURL *url = [NSURL URLWithString:urlstring];
    CFURLRef *URL = CFBridgingRetain(url);
    NSArray *proxies = (__bridge NSArray *) CFNetworkCopyProxiesForURL((CFURLRef) URL, (CFDictionaryRef) dicRef);
    //NSLog(@"%@",proxies.count);
    
    const NSString *proxyStr4 = [proxies objectAtIndex:0];
    NSLog(@"%@",proxyStr4);
    //Auto Config Alt 2 Proxy Details
   // const NSString* proxyStr4 = (const NSString*)CFDictionaryGetValue(dicRef, (const void*)CFNetworkCopyProxiesForAutoConfigurationScript);
    
    //Updating Text View for Manual Proxy
    if(proxyStr == nil)
    self.randLabel1.text=@"Manual Proxy: No Manual Proxy";
    else
    self.randLabel1.text=[NSString stringWithFormat: @"Manual Proxy: %@", proxyStr];
    
    //Updating Text View for AutoConfig Proxy
    if(proxyStr2 == nil)
    self.randLabel2.text=@"Auto Proxy: No Auto Proxy";
    else
        NSLog(@"nothing");
   // self.randLabel2.text=[NSString stringWithFormat: @"Auto Proxy: %@", proxyStr2];
    
    
    //Updating Text View for AutoConfig Proxy
    /*if(proxyStr3 == nil)
    self.randLabel3.text=@"Auto Proxy Alt: No Auto Proxy Alt config";
    else
    self.randLabel3.text=[NSString stringWithFormat: @"Auto Proxy Alt: %@", proxyStr3];*/
    
    //Check if the device running the IPA is Real device or Simulator
#if TARGET_IPHONE_SIMULATOR
    NSString * const DeviceMode = @"Simulator";
#else
    NSString * const DeviceMode = @"Real Device";
#endif
    
    NSLog(@"%@",DeviceMode);
    
    //Updating Text View for AutoConfig Proxy
    if(DeviceMode == nil)
        self.randLabel4.text=@"Device Type: No Device Type Detected";
    else
    self.randLabel4.text=[NSString stringWithFormat: @"Device Type: %@", DeviceMode];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
