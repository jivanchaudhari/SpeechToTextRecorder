//
//  ViewController.h
//  JCRecorder
//
//  Created by Mindrose on 06/07/17.
//  Copyright © 2017 Mindrose. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <Speech/Speech.h>

@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UILabel *displayLabel;

- (IBAction)recordButtonAction:(id)sender;
- (IBAction)stopButtonAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;


@end

