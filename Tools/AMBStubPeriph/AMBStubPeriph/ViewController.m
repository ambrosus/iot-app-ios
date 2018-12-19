//
//  ViewController.m
//  AMBStubPeriph
//
//  Created by serj e on 12/19/18.
//  Copyright © 2018 Ambrosus. All rights reserved.
//

#import "ViewController.h"
#import "AMIRuuviFrame.h"
#import "AMIStubPeripheralServer.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISlider *batterySlider;
@property (nonatomic, weak) IBOutlet UISlider *rssiSlider;
@property (nonatomic, weak) IBOutlet UISlider *temperatureSlider;
@property (nonatomic, weak) IBOutlet UISlider *pressureSlider;
@property (nonatomic, weak) IBOutlet UISlider *humiditySlider;
@property (nonatomic, strong) AMIStubPeripheralServer *server;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.server = [[AMIStubPeripheralServer alloc] init];
    self.server.serviceName = @"BredService";
    self.server.serviceUUID = [CBUUID UUIDWithString:@"7e57"];
    self.server.characteristicUUID = [CBUUID UUIDWithString:@"b71e"];
    [self.server resetPeripheralManager];
    [self updateRuuviFrame];
}

- (IBAction)sliderChanged:(id)sender {
    [self updateRuuviFrame];
}

- (void)updateRuuviFrame {
    AMIRuuviFrame *frame = [[AMIRuuviFrame alloc] initDefault];
    frame.voltage = (double)self.batterySlider.value;
    frame.temperature = (double)self.temperatureSlider.value;
    frame.pressure = (double)self.pressureSlider.value;
    frame.humidity = (double)self.humiditySlider.value;

    self.server.ruuviFrame = frame;
}

@end
