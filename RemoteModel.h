//
//  RemoteModel.h
//  Created by Nitin Shantharam on 12/24/11.
//

#import <Foundation/Foundation.h>

typedef void (^RemoteModelBasicBlock)(void);

@interface RemoteModel : NSObject {
    NSString *baseURL;
    RemoteModelBasicBlock completionBlock;
    RemoteModelBasicBlock failureBlock;
    NSString *apiToken;
    NSError *error;
    id response;
}

@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) id response;;

- (id)initWithBaseURL:(NSString*)aBaseUrl;
- (void)findAll;
- (void)findOne:(NSString*)anId;
- (void)create:(NSDictionary*)params;
- (void)update:(NSString*)anId params:(NSDictionary*)params;
- (void)destroy:(NSString*)anId;
- (void)actionOnResource:(NSString*)anId action:(NSString*)anAction postParams:(NSDictionary*)params;
- (void)get:(NSString*)url;
- (void)post:(NSString*)url postParams:(NSDictionary*)postParams;
- (void)setCompletionBlock:(RemoteModelBasicBlock)aCompletionBlock;
- (void)setFailedBlock:(RemoteModelBasicBlock)aFailedBlock;
- (void)signWithApiToken:(NSString*)anApiToken;

@end
