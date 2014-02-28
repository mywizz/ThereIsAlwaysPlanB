#line 1 "/Users/mywizz/Dropbox/dev/jailbreak/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB.xm"

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


#include <logos/logos.h>
#include <substrate.h>
@class SBApplicationController; @class SBUIController; @class SBTodayTableHeaderView; 
static SBTodayTableHeaderView * (*_logos_orig$_ungrouped$SBTodayTableHeaderView$initWithFrame$)(SBTodayTableHeaderView*, SEL, CGRect); static SBTodayTableHeaderView * _logos_method$_ungrouped$SBTodayTableHeaderView$initWithFrame$(SBTodayTableHeaderView*, SEL, CGRect); static id (*_logos_meta_orig$_ungrouped$SBTodayTableHeaderView$defaultFont)(Class, SEL); static id _logos_meta_method$_ungrouped$SBTodayTableHeaderView$defaultFont(Class, SEL); static void (*_logos_orig$_ungrouped$SBTodayTableHeaderView$layoutSubviews)(SBTodayTableHeaderView*, SEL); static void _logos_method$_ungrouped$SBTodayTableHeaderView$layoutSubviews(SBTodayTableHeaderView*, SEL); static void _logos_method$_ungrouped$SBTodayTableHeaderView$handleDateLabelTap$(SBTodayTableHeaderView*, SEL, id); static void _logos_method$_ungrouped$SBTodayTableHeaderView$handleAddButton$(SBTodayTableHeaderView*, SEL, id); static void _logos_method$_ungrouped$SBTodayTableHeaderView$alertView$willDismissWithButtonIndex$(SBTodayTableHeaderView*, SEL, UIAlertView *, NSInteger); static void _logos_method$_ungrouped$SBTodayTableHeaderView$sendTextToPlanbe$isTask$(SBTodayTableHeaderView*, SEL, NSString *, BOOL); 
static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBApplicationController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBApplicationController"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBUIController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBUIController"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBTodayTableHeaderView(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBTodayTableHeaderView"); } return _klass; }
#line 33 "/Users/mywizz/Dropbox/dev/jailbreak/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB.xm"


static SBTodayTableHeaderView * _logos_method$_ungrouped$SBTodayTableHeaderView$initWithFrame$(SBTodayTableHeaderView* self, SEL _cmd, CGRect frame) {
    SBTodayTableHeaderView *view = _logos_orig$_ungrouped$SBTodayTableHeaderView$initWithFrame$(self, _cmd, frame);
    
    UILabel *_dateLabel = CHIvar(view, _dateLabel, UILabel *);

	if (_dateLabel)
	{
		_dateLabel.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDateLabelTap:)];
		[_dateLabel addGestureRecognizer:tap];
		
		UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDateLabelLongTap:)];
		[_dateLabel addGestureRecognizer:longTap];
		
		UIColor *defaultColor = [_logos_static_class_lookup$SBTodayTableHeaderView() defaultTextColor];
		
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


static id _logos_meta_method$_ungrouped$SBTodayTableHeaderView$defaultFont(Class self, SEL _cmd) {
	UIFont *origFont = _logos_meta_orig$_ungrouped$SBTodayTableHeaderView$defaultFont(self, _cmd);
	UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:origFont.fontName size:origFont.pointSize - 6];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:origFont.pointSize - 6];
	return font;
}


static void _logos_method$_ungrouped$SBTodayTableHeaderView$layoutSubviews(SBTodayTableHeaderView* self, SEL _cmd) {
	_logos_orig$_ungrouped$SBTodayTableHeaderView$layoutSubviews(self, _cmd);
	
	UILabel *_dateLabel = CHIvar(self, _dateLabel, UILabel *);
	
	addButton.center = _dateLabel.center;
	CGRect rect = addButton.frame;
	rect.origin.x = self.frame.size.width - 40 - _dateLabel.frame.origin.x;
	rect.origin.y -= 5;
	
	addButton.frame = rect;
}




static void _logos_method$_ungrouped$SBTodayTableHeaderView$handleDateLabelTap$(SBTodayTableHeaderView* self, SEL _cmd, id sender) {
	for (NSString *bundleID in PLANBE_SCHEMES)
	{
		SBApplication* app = [[_logos_static_class_lookup$SBApplicationController() sharedInstance] applicationWithDisplayIdentifier:bundleID];
		if (app)
		{
			SBUIController *sbInstance = [_logos_static_class_lookup$SBUIController() sharedInstance];
			[sbInstance activateApplicationAnimated:app];
			return;
		}
	}
}




static void _logos_method$_ungrouped$SBTodayTableHeaderView$handleAddButton$(SBTodayTableHeaderView* self, SEL _cmd, id sender) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlanBe 일정/할 일 입력" message:@"" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"일정", @"할 일", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert show];
}




static void _logos_method$_ungrouped$SBTodayTableHeaderView$alertView$willDismissWithButtonIndex$(SBTodayTableHeaderView* self, SEL _cmd, UIAlertView * alertView, NSInteger buttonIndex) {
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




static void _logos_method$_ungrouped$SBTodayTableHeaderView$sendTextToPlanbe$isTask$(SBTodayTableHeaderView* self, SEL _cmd, NSString * text, BOOL isTask) {
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


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBTodayTableHeaderView = objc_getClass("SBTodayTableHeaderView"); Class _logos_metaclass$_ungrouped$SBTodayTableHeaderView = object_getClass(_logos_class$_ungrouped$SBTodayTableHeaderView); MSHookMessageEx(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$SBTodayTableHeaderView$initWithFrame$);MSHookMessageEx(_logos_metaclass$_ungrouped$SBTodayTableHeaderView, @selector(defaultFont), (IMP)&_logos_meta_method$_ungrouped$SBTodayTableHeaderView$defaultFont, (IMP*)&_logos_meta_orig$_ungrouped$SBTodayTableHeaderView$defaultFont);MSHookMessageEx(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBTodayTableHeaderView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(handleDateLabelTap:), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$handleDateLabelTap$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(handleAddButton:), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$handleAddButton$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIAlertView *), strlen(@encode(UIAlertView *))); i += strlen(@encode(UIAlertView *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(alertView:willDismissWithButtonIndex:), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$alertView$willDismissWithButtonIndex$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBTodayTableHeaderView, @selector(sendTextToPlanbe:isTask:), (IMP)&_logos_method$_ungrouped$SBTodayTableHeaderView$sendTextToPlanbe$isTask$, _typeEncoding); }} }
#line 156 "/Users/mywizz/Dropbox/dev/jailbreak/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB/ThereIsAlwaysPlanB.xm"
