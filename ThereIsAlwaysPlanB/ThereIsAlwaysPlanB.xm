
#import <CaptainHook/CaptainHook.h>
#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>
#import "NSString+Extra.h"


#define PLANBE_SCHEMES @[@"com.namu.planbe", @"com.nemus.planbe", @"com.nemus.planbelite"]
#define PLANBE_URL_TEMPLATE @"namuplanbe://x-callback-url/parse?title=%@&type=[%@]&prompt=[n]"
#define PLANBE_URL_TEMPLATE_LITE @"namuplanbelite://x-callback-url/parse?title=%@&type=[%@]&prompt=[n]"


static UIButton *addButton;

@interface SBTodayTableHeaderView : UIView {
    UILabel *_dateLabel;
}

+ (id)defaultTextColor;

@end


@interface SBTodayTableHeaderView (NEW)

- (void)handleDateLabelTap:(id)sender;
- (void)handleAddButton:(id)sender;
- (void)sendTextToPlanbe:(NSString *)text isTask:(BOOL)isTask;

@end


%hook SBTodayTableHeaderView

- (SBTodayTableHeaderView *)initWithFrame:(CGRect)frame {
    SBTodayTableHeaderView *view = %orig(frame);
    
    UILabel *_dateLabel = CHIvar(view, _dateLabel, UILabel *);

	if (_dateLabel)
	{
		_dateLabel.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDateLabelTap:)];
		[_dateLabel addGestureRecognizer:tap];
		
		UIColor *defaultColor = [%c(SBTodayTableHeaderView) defaultTextColor];
		
		addButton = [[UIButton alloc] initWithFrame:CGRectMake(_dateLabel.frame.origin.x + _dateLabel.frame.size.width,_dateLabel.origin.y, 50, 50)];
		addButton.backgroundColor = [UIColor clearColor];
		[addButton setTitle:@"+" forState:UIControlStateNormal];
		[addButton setTitleColor:defaultColor forState:UIControlStateNormal];
		[addButton addTarget:self action:@selector(handleAddButton:) forControlEvents:UIControlEventTouchUpInside];
		addButton.titleLabel.font = [UIFont systemFontOfSize:50];
		[view addSubview:addButton];
	}
    return view;
}

+ (id)defaultFont
{
	UIFont *origFont = %orig;
	UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:origFont.fontName size:origFont.pointSize - 6];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:origFont.pointSize - 6];
	return font;
}

- (void)layoutSubviews
{
	%orig;
	
	UILabel *_dateLabel = CHIvar(self, _dateLabel, UILabel *);
	
	addButton.center = _dateLabel.center;
	CGRect rect = addButton.frame;
	rect.origin.x = self.frame.size.width - 40 - _dateLabel.frame.origin.x;
	rect.origin.y -= 5;
	
	addButton.frame = rect;
}

%new

- (void)handleDateLabelTap:(id)sender
{
	for (NSString *bundleID in PLANBE_SCHEMES)
	{
		SBApplication* app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:bundleID];
		if (app)
		{
			SBUIController *sbInstance = [%c(SBUIController) sharedInstance];
			[sbInstance activateApplicationAnimated:app];
			return;
		}
	}
}

%new

- (void)handleAddButton:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlanBe 일정/할 일 입력" message:@"" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"일정", @"할 일", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert show];
}

%new

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		UITextField *field = [alertView textFieldAtIndex:0];
		NSString *title = field.text;

		if (title.length)
		{
			if (buttonIndex == 1)
			{
				[self sendTextToPlanbe:title isTask:NO];
			}
			else if (buttonIndex == 2)
			{
				[self sendTextToPlanbe:title isTask:YES];
			}
		}
	}
}

%new

- (void)sendTextToPlanbe:(NSString *)text isTask:(BOOL)isTask
{
	NSString *encodedText = [text URLEncodedString];
	
	NSString *urlString = [NSString stringWithFormat:PLANBE_URL_TEMPLATE, encodedText , isTask ? @"t" : @"e"];
	NSString *urlString2 = [NSString stringWithFormat:PLANBE_URL_TEMPLATE_LITE, encodedText, isTask ? @"t" : @"e"];
	NSArray *urls = @[
					  [NSURL URLWithString:urlString],
					  [NSURL URLWithString:urlString2]
					  ];
	
	for (NSURL *url in urls)
	{
		if ([[UIApplication sharedApplication] canOpenURL:url])
		{
			[[UIApplication sharedApplication] openURL:url];
			return;
		}
	}
}

%end