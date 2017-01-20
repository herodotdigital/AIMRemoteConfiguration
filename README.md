#AIMRemoteConfiguration

AIMRemoteConfiguration allows you to define a list of colors used in the app in JSON file and fetch it from the internet. It works in an asynchronous way. The app starts normally, fetches all data in the background, and applies all styles on next start, so the user doesn't see any loader at the beginning.

#Usage

- Add a category for `UIColor`:
```objective-c
#import "RemoteConfiguration.h"

@implementation UIColor (list)

+ (UIColor *)backgroundColor {
    return [RemoteConfiguration colorWithName:@"background"]?: [UIColor whiteColor];
}

+ (UIColor *)textColor {
    return [RemoteConfiguration colorWithName:@"text"]?: [UIColor blackColor];
}

@end
```
- Setup in `AppDelegate.m`
```objective-c
#import "AppDelegate.h"
#import "RemoteConfiguration.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RemoteConfiguration setup];
    return YES;
}
 @end
```
- Add `theme.json` file with default config for your app:

```json
{
    "colors": {
        "background": "##d35400",
        "text": "#000000"
    }
}
```
- Add config to `Info.plist`:
 - `themeFileName` - name of default config without extension (`theme` in our example)
 - `themeRemotePath` - path to remote config (`https://allinmobile.github.io/AIMRemoteConfiguration/remote_theme.json` in our example) **remember about HTTPS**
 
- Use in the app, i.e:
 
```objective-c
#import "ViewController.h"
#import "UIColor+list.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *quotation;
@property (weak, nonatomic) IBOutlet UILabel *citation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.quotation.textColor = [UIColor textColor];
    self.citation.textColor = [UIColor textColor];
}


@end
```

#Installation

Use the [CocoaPods](http://github.com/CocoaPods/CocoaPods).

Add to your Podfile
>`pod 'AIMRemoteConfiguration'`

and then call

>`pod install`

and import 

>`#import "RemoteConfiguration.h"`

#Example

Check folder `Example` for a simple application with `AIMRemoteConfiguration` integrated.
