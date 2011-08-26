//
//  Label.m
//  chat
//
//  Created by Pedro Enrique on 8/13/11.
//  Copyright 2011 Appcelerator. All rights reserved.
//

#import "PESMSLabel.h"
#import "TiHost.h"

@implementation PESMSLabel

@synthesize rColor;
@synthesize sColor;
@synthesize isText;
@synthesize isImage;

-(void)dealloc
{
	RELEASE_TO_NIL(label);
	RELEASE_TO_NIL(innerImage);
	[super dealloc];
}

-(UIImageView *)innerImage:(UIImage *)image
{
	if(!innerImage)
	{
		innerImage = [[UIImageView alloc] initWithImage:image];
		self.isImage = YES;
	}
	return innerImage;
}

-(UILabel *)label
{
	if(!label)
	{
		label = [[UILabel alloc] init];
		label.numberOfLines = 0;
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Helvica" size:50]];
		self.isText = YES;
	}
	return label;
}

-(void)setUpTextImageSize
{
	CGRect x = [self label].frame;
	if(x.size.width > self.superview.frame.size.width-100)
	{
		x.size.width = self.superview.frame.size.width-100;
		[[self label] setFrame:x];
		[[self label] sizeToFit];
		
	}
	CGRect a = [self label].frame;
	a.size.width +=25;
	a.size.height +=10;
	a.origin.y = 10;
	a.origin.x = 10;
	self.frame = a;
	
	CGRect b = [self label].frame;
	b.origin.y = 3;
	b.origin.x = 15;
	[[self label] setFrame:b];
}

-(void)setUpInnerImageImageSize
{
	CGRect x = [self innerImage:nil].frame;
	if(x.size.width > self.superview.frame.size.width-100)
	{
		x.size.width = self.superview.frame.size.width-100;
		[[self innerImage:nil] setFrame:x];
		[[self innerImage:nil] sizeToFit];
		
	}
	CGRect a = [self innerImage:nil].frame;
	a.size.width +=25;
	a.size.height +=20;
	a.origin.y = 10;
	a.origin.x = 10;
	self.frame = a;
	
	CGRect b = [self innerImage:nil].frame;
	b.origin.y = 8;
	
	b.origin.x = 15;
	
	[[self innerImage:nil] setFrame:b];
}


-(void)addText:(NSString *)text
{
	
	[[self label] performSelectorOnMainThread : @selector(setText:) withObject:text waitUntilDone:YES];
	[self addSubview:[self label]];
	[[self label] sizeToFit];
	[self setUpTextImageSize];
	
}

-(void)addImage:(UIImage *)image
{
	[self addSubview:[self innerImage:image]];
	[[self innerImage:nil] sizeToFit];
	[self setUpInnerImageImageSize];
}

-(NSString*)getNormalizedPath:(NSString*)source
{
	if ([source hasPrefix:@"file:/"]) {
		NSURL* url = [NSURL URLWithString:source];
		return [url path];
	}
	return source;
}

-(NSString *)resourcesDir:(NSString *)url
{
	url = [[TiHost resourcePath] stringByAppendingPathComponent:[self getNormalizedPath:url]];
	
	return url;
}

-(void)position:(NSString *)pos:(NSString *)color
{
	if([pos isEqualToString:@""] || !pos)
		pos = @"Left";
	if([color isEqualToString:@""] || !color)
		color = @"Green";
	
	NSString *imgName = [[[[@"smsview.bundle/"
							stringByAppendingString:color ]
							stringByAppendingString:@"Balloon"]
							stringByAppendingString:pos]
							stringByAppendingString:@".png" ];
	
	imgName = [self resourcesDir:imgName];
	
	if([pos isEqualToString:@"Left"])
	{
		if(self.isText)
		{
			CGRect a = [self label].frame;
			a.origin.x +=5;
			[[self label] setFrame:a];
		}
		if(self.isImage)
		{
			CGRect a = [self innerImage:nil].frame;
			a.origin.x +=5;
			[[self innerImage:nil] setFrame:a];
		}
		
		CGRect b = self.frame;
		b.size.width +=10;
		[self setFrame:b];		
		self.image = [[UIImage imageWithContentsOfFile:imgName] stretchableImageWithLeftCapWidth:22 topCapHeight:14];
	}
	else if([pos isEqualToString:@"Right"])
	{
		self.image = [[UIImage imageWithContentsOfFile:imgName] stretchableImageWithLeftCapWidth:20 topCapHeight:14];
		CGRect a = self.frame;
		a.origin.x = (self.superview.frame.size.width-self.frame.size.width)-20;
		a.size.width +=10;
		[self setFrame:a];
	}
	else
	{
		NSLog(@"[ERROR] need to know if it's \"Left\" or \"Right\", stupid!");
	}
}


@end
