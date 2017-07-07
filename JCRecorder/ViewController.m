//
//  ViewController.m
//  JCRecorder
//
//  Created by Mindrose on 06/07/17.
//  Copyright © 2017 Mindrose. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    SFSpeechRecognizer *_recognizer;

    NSURL *outputFileURL;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_stopButton setEnabled:NO];
    [_playButton setEnabled:NO];
    _displayLabel.text = @" ";

    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [_stopButton setEnabled:NO];
    [_playButton setEnabled:YES];
}

- (IBAction)recordButtonAction:(id)sender {
    _displayLabel.text = @" ";

    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [_recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [_stopButton setEnabled:YES];
    [_playButton setEnabled:NO];
}
- (IBAction)stopButtonAction:(id)sender {
    [recorder stop];
    _displayLabel.text = @" ";

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playButtonAction:(id)sender {
     _displayLabel.text = @" ";
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        
        SFSpeechRecognizer *recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-IN"]];
        
        //Now it's part for request
        SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:outputFileURL];
        
        //
        [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if(error != nil)
            {
                NSLog(@"My Error:%@",error);
            }
            
            NSLog(@"My Test:%@",result.bestTranscription.formattedString);
           
            NSString *transcriptText = result.bestTranscription.formattedString;
              _displayLabel.text = [[NSString alloc] initWithFormat:@"%@",result.bestTranscription.formattedString];
            NSLog(@"%@",transcriptText);

                    }];

    }
}

//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
// 
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Done" message:@"Finish playing the recording!" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:ok];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}
@end
