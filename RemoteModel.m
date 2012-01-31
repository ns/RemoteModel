//
//  RemoteModel.h
//  Created by Nitin Shantharam on 12/24/11.
//

#import "RemoteModel.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@implementation RemoteModel

@synthesize error;
@synthesize response;

- (id)initWithBaseURL:(NSString*)aBaseUrl {
    self = [super init];
    if (self) {
        baseURL = aBaseUrl;
        apiToken = nil;
    }
    return self;
}

- (void)findAll {
    if ([apiToken isEqualToString:@""] || apiToken == nil)
        [self get:baseURL];
    else
        [self get:[NSString stringWithFormat:@"%@?api_token=%@", baseURL, apiToken]];
}

- (void)findOne:(NSString*)anId {
    if ([apiToken isEqualToString:@""] || apiToken == nil)
        [self get:[NSString stringWithFormat:@"%@/%@", baseURL, anId]];
    else
        [self get:[NSString stringWithFormat:@"%@/%@?api_token=%@", baseURL, anId, apiToken]];
}

- (void)create:(NSDictionary*)params {
    if ([apiToken isEqualToString:@""] || apiToken == nil)
        [self post:[NSString stringWithFormat:@"%@", baseURL] postParams:params];
    else
        [self post:[NSString stringWithFormat:@"%@?api_token=", baseURL, apiToken] postParams:params];
}

- (void)update:(NSString*)anId params:(NSDictionary*)params {
    [params setValue:@"put" forKey:@"_method"];
    
    if (anId == nil) {
        if ([apiToken isEqualToString:@""] || apiToken == nil)
            [self post:[NSString stringWithFormat:@"%@", baseURL] postParams:params];
        else
            [self post:[NSString stringWithFormat:@"%@?api_token=%@", baseURL, apiToken] postParams:params];
    }
    else {
        if ([apiToken isEqualToString:@""] || apiToken == nil)
            [self post:[NSString stringWithFormat:@"%@/%@", baseURL, anId] postParams:params];
        else
            [self post:[NSString stringWithFormat:@"%@/%@?api_token=%@", baseURL, anId, apiToken] postParams:params];
    }
}

- (void)destroy:(NSString*)anId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"delete" forKey:@"_method"];
    
    if ([apiToken isEqualToString:@""] || apiToken == nil)
        [self post:[NSString stringWithFormat:@"%@/%@", baseURL, anId] postParams:params];
    else
        [self post:[NSString stringWithFormat:@"%@/%@?api_token=%@", baseURL, anId, apiToken] postParams:params];
}

- (void)actionOnResource:(NSString*)anId action:(NSString*)anAction postParams:(NSDictionary*)params {
    if ([apiToken isEqualToString:@""] || apiToken == nil)
        [self post:[NSString stringWithFormat:@"%@/%@/%@", baseURL, anId, anAction] postParams:params];
    else
        [self post:[NSString stringWithFormat:@"%@/%@/%@?api_token=%@", baseURL, anId, anAction, apiToken] postParams:params];
}

- (void)get:(NSString*)url {
    response = nil;
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setAllowCompressedResponse:YES];
    [request setCompletionBlock:^{
        SBJsonParser *parser = [SBJsonParser new];
        response = [parser objectWithString:[request responseString]];
        if(completionBlock){
            completionBlock();
        }
    }];
    [request setFailedBlock:^{
        error = [request error];
        if(failureBlock){
            failureBlock();
        }
    }];
    [request startAsynchronous];
}

- (void)post:(NSString*)url postParams:(NSDictionary*)postParams {
    response = nil;
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    for (NSString *key in postParams) {
        id val = [postParams objectForKey:key];
        if ([val isKindOfClass:[NSString class]]) {
            [request setPostValue:val forKey:key];
        }
        else {
            NSDictionary *dict = (NSDictionary*)val;
            [request setData:[dict objectForKey:@"data"]
                withFileName:[dict objectForKey:@"filename"]
              andContentType:[dict objectForKey:@"content_type"]
                      forKey:key];
        }
    }
    [request setCompletionBlock:^{
        SBJsonParser *parser = [SBJsonParser new];
        response = [parser objectWithString:[request responseString]];
        if(completionBlock){
            completionBlock();
        }
    }];
    [request setFailedBlock:^{
        error = [request error];
        if(failureBlock){
            failureBlock();
        }
    }];
    [request startAsynchronous];
}

- (void)setCompletionBlock:(RemoteModelBasicBlock)aCompletionBlock
{
	completionBlock = [aCompletionBlock copy];
}

- (void)setFailedBlock:(RemoteModelBasicBlock)aFailedBlock
{
	failureBlock = [aFailedBlock copy];
}

- (void)signWithApiToken:(NSString*)anApiToken {
    apiToken = anApiToken;
}

@end
