//
//  Created by Sergei E. on 12/19/18.
//  (c) 2018 Ambrosus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AMIRuuviFrame.h"

@interface AMIStubPeripheralServer : NSObject
@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) CBUUID *serviceUUID;
@property(nonatomic, strong) CBUUID *characteristicUUID;
@property(nonatomic, strong) AMIRuuviFrame *ruuviFrame;

- (id)init;
- (void)resetPeripheralManager;

@end
