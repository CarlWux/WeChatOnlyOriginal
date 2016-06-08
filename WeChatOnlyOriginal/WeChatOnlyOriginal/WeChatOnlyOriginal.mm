#import <CaptainHook/CaptainHook.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSObjCRuntime.h>
#import <substrate.h>
#import "BlackMagic.h"
CHDeclareClass(WCTimelineDataProvider);
CHDeclareClass(WCTimelineMgr);
CHDeclareClass(WCDataItem);
CHDeclareClass(WCContentItem);
CHDeclareClass(CMessageMgr);


/**
 *  插件功能
 */
static int const kClosePlugin = 0;
static int const kOpenPlugin = 1;


//0：关闭插件
//1：打开插件
static int HBPliginType = 0;


CHMethod(1, void, WCTimelineDataProvider, converListToList, id, arg1)
{
    
//    objc_property_t property = class_getProperty(objc_getClass("SnsObject"), "referId");
    
    unsigned int allPropertyCount;
    
    
    objc_property_t *allProperties = class_copyPropertyList(objc_getClass("SnsObject"), &allPropertyCount);
    
//    NSString* tmp=[NSString stringWithFormat:@"%@",arg1];
//    NSLog(@"tmp is %@",tmp);
    NSArray* array=[NSArray arrayWithArray:arg1];
    for (id snsObject in array) {
        for (unsigned int i = 0; i < allPropertyCount; i++) {
            objc_property_t property = allProperties[i];
            const char * propertyName = property_getName(property);
            NSString *propName = [NSString stringWithUTF8String:propertyName];
            id value=[snsObject valueForKey:propName];
//            NSLog(@"ProperName %@ Value %@",propName,value);
        }
    }
    
    
    CHSuper(1, WCTimelineDataProvider, converListToList, arg1);
}


//CHMethod(0, void, WCFacade, reloadTimelineDataItems){
//    CHSuper(0, WCFacade,reloadTimelineDataItems);
////    m_timelineWithLocalDatas
//    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("WCFacade"), "m_timelineWithLocalDatas");
//    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
//    
////    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
////    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
//    
//}

CHMethod(4,void,WCTimelineMgr,onDataUpdated,id,arg1,andData,id,arg2,andAdData,id,arg3,withChangedTime,id,arg4)
{

    
//    NSNumber *number = LOADSETTINGS(@"HBPliginType");
    NSNumber *number=[BlackMagic loadSettingValue:@"HBPliginType"];
    
    HBPliginType=[number intValue];
    
    if (kClosePlugin == HBPliginType ) {
        CHSuper(4, WCTimelineMgr, onDataUpdated, arg1,andData,arg2,andAdData,arg3,withChangedTime,arg4);
        return;
    }
    NSMutableArray* array=[NSMutableArray arrayWithArray:arg2];
//    NSMutableArray* resultArray=[NSMutableArray arrayWithArray:arg2];
    for (int i=0; i<array.count; i++) {
        WCDataItem* item=[array objectAtIndex:i];
        WCContentItem* contentItem=[item valueForKey:@"contentObj"];
        int contentType=[[contentItem valueForKey:@"type"] intValue];
        if (contentType==3) {
            [array removeObjectAtIndex:i];
        }
    }

    CHSuper(4, WCTimelineMgr, onDataUpdated, arg1,andData,array,andAdData,arg3,withChangedTime,arg4);
}

CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
{
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
    
    NSLog(@"msgWrap class is %@",[arg2 class]);

    
    id messageWrap=arg2;
    
    NSUInteger m_uiMessageType=[[messageWrap valueForKey:@"m_uiMessageType"] integerValue];
    
//    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
//    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
//    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
//    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
    
//    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
//    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
    
//    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
//    id m_nsContent = object_getIvar(arg2, nsContentIvar);
    
    switch(m_uiMessageType) {
        case 1:
        {
            //普通消息
            //红包插件功能
            //0：关闭原创
            //1：只看原创
            //微信的服务中心
//            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
//            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            //通讯录管理器
//            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
//            id selfContact = objc_msgSend(contactManager, @selector(getSelfContact));
//            
//            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
//            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
//            NSLog(@"--------m_nsFromUsr is %@",m_nsFromUsr);
//            NSLog(@"--------m_nsUsrName is %@",m_nsUsrName);
//            BOOL isMesasgeFromMe = NO;
            id m_nsFromUsr=[messageWrap valueForKey:@"m_nsFromUsr"];
            id m_nsToUsr=[messageWrap valueForKey:@"m_nsToUsr"];
            id m_nsContent =[messageWrap valueForKey:@"m_nsContent"];
            BOOL isMesasgeFromMe = NO;
            if ([m_nsFromUsr isEqualToString:m_nsToUsr]) {
                //发给自己的消息
                isMesasgeFromMe = YES;
            }
            
            if (isMesasgeFromMe)
            {
                if ([m_nsContent rangeOfString:@"原创"].location != NSNotFound)
                {
                    HBPliginType = kOpenPlugin;
                    Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                    IMP impMMSC = method_getImplementation(methodMMServiceCenter);
                    id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                    id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("ClearDataMgr"));
                    ((void (*)(id, SEL))objc_msgSend)(logicMgr, @selector(cleanCache));
                    
                    [BlackMagic saveSettingKey:@"HBPliginType" value:[NSNumber numberWithInt:HBPliginType]];
                    
                }
                else if ([m_nsContent rangeOfString:@"全部"].location != NSNotFound)
                {
                    HBPliginType = kClosePlugin;
                    Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                    IMP impMMSC = method_getImplementation(methodMMServiceCenter);
                    id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                    id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("ClearDataMgr"));
                    ((void (*)(id, SEL))objc_msgSend)(logicMgr, @selector(cleanCache));
                    
                    [BlackMagic saveSettingKey:@"HBPliginType" value:[NSNumber numberWithInt:HBPliginType]];
                    
                }
                
                
                
                
            }
        }
            break;
        default:
            break;
    }
}

__attribute__((constructor)) static void entry()
{
    NSLog(@"Start Hook!");
    
    CHLoadLateClass(WCTimelineDataProvider);
    CHClassHook(1, WCTimelineDataProvider,converListToList);

    CHLoadLateClass(WCTimelineMgr);
    CHClassHook(4, WCTimelineMgr,onDataUpdated,andData,andAdData,withChangedTime);
    
    CHLoadLateClass(CMessageMgr);
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
    
//    CHLoadLateClass(WCFacade);
//    CHClassHook(0, WCFacade,reloadTimelineDataItems);

}

