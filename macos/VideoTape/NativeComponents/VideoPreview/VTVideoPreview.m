#import "VTVideoPreview.h"
#import <Cocoa/Cocoa.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>

@implementation VTVideoPreview {
  AVPlayer *_player;
}

- (instancetype)init
{
  if ((self = [super init])) {
    //[self setControlsStyle:AVPlayerViewControlsStyleNone];
    [self setControlsStyle:AVPlayerViewControlsStyleMinimal];
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
  }
  return self;
}

- (void)attachListeners
{
  // listen for end of file
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(playerItemDidReachEnd:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:[_player currentItem]];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
  AVPlayerItem *item = [notification object];
  [NSTimer scheduledTimerWithTimeInterval:1.0f
                                   target:self
                                 selector:@selector(restart:)
                                 userInfo:item
                                  repeats:NO];
  
  
}

- (void)restart:(NSTimer *)timer
{
   [((AVPlayerItem *)timer.userInfo) seekToTime:kCMTimeZero];
}

- (void)setSrc:(NSString *)url
{
  _player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
  _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
  [self setPlayer:_player];
  [self attachListeners];
}

@end