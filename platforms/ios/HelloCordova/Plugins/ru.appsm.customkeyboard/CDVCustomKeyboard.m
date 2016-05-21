#import "CDVCustomKeyboard.h"

@interface CDVCustomKeyboard ()<UITextViewDelegate>

@property (nonatomic, readwrite, assign) BOOL keyboardIsVisible;

@end

@implementation CDVCustomKeyboard

UITextView *hiddenTextView;
bool isKeyboard = false;

- (void)pluginInitialize
{
    if (hiddenTextView == NULL) {
        hiddenTextView = [[UITextView alloc] init];
        hiddenTextView.alpha = 0;
        hiddenTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        hiddenTextView.bounds = CGRectMake(0, 0, 0, 0);
        hiddenTextView.keyboardType = UIKeyboardTypeDecimalPad;
        hiddenTextView.delegate = self;
        [self.viewController.view addSubview:hiddenTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    isKeyboard = true;
    NSLog(@"Keyboard is active.");
    NSLog(@"a is %i ", isKeyboard);

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    isKeyboard = false;
    NSLog(@"Keyboard is hidden");
    NSLog(@"a is %i ", isKeyboard);
 
 
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult  callbackId:self.callbackId];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    NSString *text = textView.text;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:text];
    [self.commandDelegate sendPluginResult:pluginResult  callbackId:self.callbackId];
}

- (void)open:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSString *startedValue = [command argumentAtIndex:0];
    NSInteger keyBoardTypeInt = [[command argumentAtIndex:1] integerValue];
    
    switch (keyBoardTypeInt) {
        case 1:
            self.keyboardType =  UIKeyboardTypeDefault;                // Default type for the current input method.
            break;
        case 2:
            self.keyboardType =  UIKeyboardTypeASCIICapable;                // Default type for the current input method.
            break;
        case 3:
            self.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;                // Default type for the current input method.
            break;
        case 4:
            self.keyboardType =  UIKeyboardTypeURL;                // Default type for the current input method.
            break;
        case 5:
            self.keyboardType =  UIKeyboardTypeNumberPad;                // Default type for the current input method.
            break;
        case 6:
            self.keyboardType =  UIKeyboardTypePhonePad;                // Default type for the current input method.
            break;
        case 7:
            self.keyboardType =  UIKeyboardTypeNamePhonePad;                // Default type for the current input method.
            break;
        case 8:
            self.keyboardType =  UIKeyboardTypeEmailAddress;                // Default type for the current input method.
            break;
        case 9:
            self.keyboardType =  UIKeyboardTypeDecimalPad;                // Default type for the current input method.
            break;
        case 10:
            self.keyboardType =  UIKeyboardTypeTwitter;                // Default type for the current input method.
            break;
        case 11:
            self.keyboardType =  UIKeyboardTypeWebSearch;                // Default type for the current input method.
            break;
        default:
            self.keyboardType =  keyBoardTypeInt;
            break;
    }
    hiddenTextView.keyboardType = self.keyboardType;
    hiddenTextView.text = startedValue;
    isKeyboard = true;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleDefault;
    toolbar.translucent = YES;
    toolbar.tintColor = [UIColor blueColor];
    
    // Create a flexible space to align buttons to the right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Create a done button to dismiss the keyboard
    UIBarButtonItem *barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneView)];
    
    // Create a cancel button to dismiss the keyboard
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    
    // Add buttons to the toolbar
    [toolbar setItems:[NSArray arrayWithObjects: barButtonItemCancel,  flexibleSpace, barButtonItemDone, nil]];
    
    // Set the toolbar as accessory view of an UITextField object
    hiddenTextView.inputAccessoryView = toolbar;
    
    [hiddenTextView becomeFirstResponder];

}
- (void) doneView{
    [self.webView becomeFirstResponder];
    [hiddenTextView resignFirstResponder];
}

- (void) cancelView {
    [self.webView becomeFirstResponder];
    [hiddenTextView resignFirstResponder];
    //hiddenTextView.text = [NSString stringWithFormat:@"%@/%@", hiddenTextView.text, @"00"];
    //[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]  callbackId:command.callbackId];
}



- (void)close:(CDVInvokedUrlCommand*)command
{
    [self.webView becomeFirstResponder];
    [hiddenTextView resignFirstResponder];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]  callbackId:command.callbackId];
}

- (void)change:(CDVInvokedUrlCommand*)command
{
    NSString *value = [command argumentAtIndex:0];
    hiddenTextView.text = value;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isKeyboardOnScreen:(CDVInvokedUrlCommand*)command
{
    [self.webView becomeFirstResponder];
    isKeyboard = [self isKeyboardOnScreen];
     NSString *result = (isKeyboard == true) ? @"Open":@"Closed";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (BOOL) isKeyboardOnScreen
{
    BOOL isKeyboardShown = NO;
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count > 1) {
        NSArray *wSubviews =  [windows[1]  subviews];
        if (wSubviews.count) {
            CGRect keyboardFrame = [wSubviews[0] frame];
            CGRect screenFrame = [windows[1] frame];
            if (keyboardFrame.origin.y+keyboardFrame.size.height == screenFrame.size.height) {
                isKeyboardShown = YES;
            }
        }
    }
    
    return isKeyboardShown;
}
@end
