//
//  Created by Sergei E. on 12/19/18.
//  (c) 2018 Ambrosus. All rights reserved.
//

#import "AMIStubPeripheralServer.h"

@interface AMIStubPeripheralServer () <CBPeripheralManagerDelegate>

@property(nonatomic, strong) CBPeripheralManager *peripheralMan;
@property(nonatomic, strong) CBMutableCharacteristic *characteristic;
@property(nonatomic, strong) CBMutableService *service;
@property(nonatomic, strong) NSData *pendingData;
@property(nonatomic, assign) BOOL dataIsDirty;

@end

@implementation AMIStubPeripheralServer

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)resetPeripheralManager {
    if (self.peripheralMan) {
        [self.peripheralMan removeAllServices];
        [self.peripheralMan stopAdvertising];
        self.peripheralMan = nil;
    }
    self.service = nil;
    self.peripheralMan = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)setRuuviFrame:(AMIRuuviFrame *)ruuviFrame {
    if (ruuviFrame != _ruuviFrame) {
        _ruuviFrame = ruuviFrame;
        self.dataIsDirty = YES;
        [self resetPeripheralManager];
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBManagerStatePoweredOn: {
            NSLog(@"peripheralStateChange: Powered On");
            [self enableService];
            break;
        }
            
        case CBManagerStatePoweredOff: {
            NSLog(@"peripheralStateChange: Powered Off");
            [self disableService];
            break;
        }
            
        case CBManagerStateResetting: {
            NSLog(@"peripheralStateChange: Resetting");
            
            break;
        }
            
        case CBManagerStateUnauthorized: {
            NSLog(@"peripheralStateChange: Deauthorized");
            [self disableService];
            break;
        }
            
        case CBManagerStateUnsupported: {
            NSLog(@"peripheralStateChange: Unsupported");
            break;
        }
            
        case CBManagerStateUnknown: {
            NSLog(@"peripheralStateChange: Unknown");
            break;
        }
            
        default:
            break;
    }
}

- (void)enableService {
    if (self.service) {
        [self.peripheralMan removeService:self.service];
        self.service = nil;
    }
    
//    self.service = [[CBMutableService alloc] initWithType:self.serviceUUID primary:YES];
//    self.characteristic = [[CBMutableCharacteristic alloc] initWithType:self.characteristicUUID
//                                                             properties:CBCharacteristicPropertyNotify
//                                                                  value:nil
//                                                            permissions:0];
//
//    self.service.characteristics = @[self.characteristic];
//    [self.peripheralMan addService:self.service];
    [self startAdvertising];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    [self startAdvertising];
}

- (void)startAdvertising {
    if (self.peripheralMan.isAdvertising) {
        [self.peripheralMan stopAdvertising];
    }
    
    NSMutableDictionary *advDict = [@{/*CBAdvertisementDataServiceUUIDsKey : @[self.serviceUUID],*/
                                      CBAdvertisementDataLocalNameKey: self.serviceName} mutableCopy];
    
    if (self.ruuviFrame) {
        NSData *dataFrame = [self.ruuviFrame dataFrame];
        if (dataFrame) {
            advDict[CBAdvertisementDataLocalNameKey] = [dataFrame base64EncodedStringWithOptions:0];
        }
    }
    
    [self.peripheralMan startAdvertising:advDict];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"didStartAdvertising %@", error);
}

- (void)disableService {
    [self.peripheralMan removeService:self.service];
    self.service = nil;
    [self.peripheralMan stopAdvertising];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(nonnull CBCharacteristic *)characteristic {
    NSLog(@"didSubscribe: CHARS:%@ CENTRAL:%@", characteristic.UUID, central.identifier);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"didUnsubscribe: %@", central.identifier);
}

@end
