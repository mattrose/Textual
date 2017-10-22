/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

 Copyright (c) 2010 - 2017 Codeux Software, LLC & respective contributors.
        Please see Acknowledgements.pdf for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Textual and/or "Codeux Software, LLC", nor the 
      names of its contributors may be used to endorse or promote products 
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

NS_ASSUME_NONNULL_BEGIN

@implementation ICMInlineHTML

- (void)performActionForHTML:(NSString *)unescapedHTML
{
	NSParameterAssert(unescapedHTML != nil);

	ICLPayloadMutable *payload = self.payload;

	NSDictionary *templateAttributes =
	@{
		@"classAttribute" : self.classAttribute,
		@"unescapedHTML" : unescapedHTML,
		@"uniqueIdentifier" : payload.uniqueIdentifier
	};

	NSError *templateRenderError = nil;

	NSString *html = [self.template renderObject:templateAttributes error:&templateRenderError];

	payload.html = html;

	self.completionBlock(templateRenderError);
}

- (void)notifyUnableToPresentHTML
{
	self.completionBlock(self.genericValidationFailedError);
}

#pragma mark -
#pragma mark Action Block

+ (ICLInlineContentModuleActionBlock)actionBlockForHTML:(NSString *)html
{
	NSParameterAssert(html != nil);

	return [^(ICLInlineContentModule *module) {
		__weak ICMInlineHTML *moduleTyped = (id)module;

		[moduleTyped performActionForHTML:html];
	} copy];
}

@end

#pragma mark -
#pragma mark Foundation

@implementation ICMInlineHTMLFoundation

- (nullable NSArray<NSURL *> *)styleResources
{
	static NSArray<NSURL *> *styleResources = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		styleResources =
		@[
		  [RZMainBundle() URLForResource:@"ICMInlineHTML" withExtension:@"css" subdirectory:@"Components"]
		];
	});

	return styleResources;
}

- (nullable NSArray<NSURL *> *)scriptResources
{
	static NSArray<NSURL *> *scriptResources = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		scriptResources =
		@[
		  [RZMainBundle() URLForResource:@"ICMInlineHTML" withExtension:@"js" subdirectory:@"Components"]
		];
	});

	return scriptResources;
}

- (nullable NSURL *)templateURL
{
	return [RZMainBundle() URLForResource:@"ICMInlineHTML" withExtension:@"mustache" subdirectory:@"Components"];
}

- (nullable NSString *)entrypoint
{
	return @"_ICMInlineHTML";
}

+ (BOOL)contentUntrusted
{
	return YES;
}

- (NSString *)classAttribute
{
	return @"";
}

@end

NS_ASSUME_NONNULL_END
