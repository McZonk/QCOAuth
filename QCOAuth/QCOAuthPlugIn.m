/*
 Copyright (c) 2013 Boinx Software Ltd.
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QCOAuthPlugIn.h"

#import "QCOAMutableURLRequest.h"


#ifndef NSAppKitVersionNumber10_7
#define NSAppKitVersionNumber10_7 1138
#endif




@interface QCOAuthPlugIn ()

+ (NSBundle *)bundle;

@end



@implementation QCOAuthPlugIn

@dynamic inputURL;
@dynamic inputConsumerKey;
@dynamic inputConsumerSecret;
@dynamic inputTokenKey;
@dynamic inputTokenSecret;
@dynamic inputUpdate;

@dynamic outputAuthorization;
@dynamic outputHTTPHeader;


+ (NSBundle *)bundle
{
	return [NSBundle bundleForClass:self];
}

+ (NSDictionary *)attributes
{
	return @{
		QCPlugInAttributeNameKey: @"OAuth",
		QCPlugInAttributeDescriptionKey: @"Generates Authorization Requests for OAuth services",
		QCPlugInAttributeCopyrightKey: @"© 2013 Boinx Software Ltd."
	};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	if([key isEqualToString:@"inputURL"])
	{
		return @{ QCPortAttributeNameKey: @"URL" };
	}
	
	if([key isEqualToString:@"inputConsumerKey"])
	{
		return @{ QCPortAttributeNameKey: @"Consumer Key" };
	}
	
	if([key isEqualToString:@"inputConsumerSecret"])
	{
		return @{ QCPortAttributeNameKey: @"Consumer Secret" };
	}
	
	if([key isEqualToString:@"inputTokenKey"])
	{
		return @{ QCPortAttributeNameKey: @"Token Key" };
	}
	
	if([key isEqualToString:@"inputTokenSecret"])
	{
		return @{ QCPortAttributeNameKey: @"Token Secret" };
	}
	
	if([key isEqualToString:@"inputUpdate"])
	{
		return @{ QCPortAttributeNameKey: @"Update" };
	}
	
	if([key isEqualToString:@"outputAuthorization"])
	{
		return @{ QCPortAttributeNameKey: @"Authorization" };
	}
	
	if([key isEqualToString:@"outputHTTPHeader"])
	{
		return @{ QCPortAttributeNameKey: @"HTTP Header" };
	}
	
	return nil;
}

+ (NSArray *)plugInKeys
{
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id)init
{
	self = [super init];
	if(self != nil)
	{
		
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

@implementation QCOAuthPlugIn (Execution)

- (BOOL)startExecution:(id<QCPlugInContext>)context
{
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
}

- (BOOL)execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	if([self didValueForInputKeyChange:@"inputUpdate"] && self.inputUpdate == YES)
	{
		@autoreleasepool
		{
			NSURL *url = [NSURL URLWithString:self.inputURL];

			QCOAConsumer *consumer = [[[QCOAConsumer alloc] initWithKey:self.inputConsumerKey secret:self.inputConsumerSecret] autorelease];
			QCOAToken *accessToken = [[[QCOAToken alloc] initWithKey:self.inputTokenKey secret:self.inputTokenSecret] autorelease];
		
			QCOAMutableURLRequest *request = [[[QCOAMutableURLRequest alloc] initWithURL:url consumer:consumer token:accessToken realm:nil signatureProvider:nil] autorelease];
			[request prepare];
			
			NSString *authorization = [request.allHTTPHeaderFields objectForKey:@"Authorization"];

			self.outputAuthorization = authorization;
			
			self.outputHTTPHeader = @{ @"Authorization": authorization };
		}
	}
	
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
}

@end
