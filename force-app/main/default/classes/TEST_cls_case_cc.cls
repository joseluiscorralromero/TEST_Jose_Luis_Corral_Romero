public class TEST_cls_case_cc {
    
    //GET Response
    public class AdjustmentsGETResponse{
        @AuraEnabled
        public List<adjustment>  	adjustmentsResponse {get; set;}
        @AuraEnabled
        public Error 				Error 				{get; set;}
        @AuraEnabled
        public integer 				code 				{get; set;} 
        
        public AdjustmentsGETResponse(){
            adjustmentsResponse = null;
            Error 				= null;
            code 				= 0;
        }
    } 
    public class adjustment{
        @AuraEnabled
        public String  	adjustmentId 		{get; set;}
        @AuraEnabled
        public String 	adjustmentStatus	{get; set;}
        
        public adjustment(){
            adjustmentId 		= null;
            adjustmentStatus 	= null;
        }
    } 
    //PATCH Response
    public class AdjustmentsPATCHResponse{
        @AuraEnabled
        public authorizeResponse  	authorizeResponse 	{get; set;}
        @AuraEnabled
        public Error 				Error 				{get; set;}
        @AuraEnabled
        public integer 				code 				{get; set;}
        
        public AdjustmentsPATCHResponse(){
            authorizeResponse 	= null;
            Error 				= null;
            code 				= 0;
        }
    } 
    public class authorizeResponse{
        @AuraEnabled
        public String authorizationGroup {get; set;}

        public authorizeResponse(){
            authorizationGroup = null;
        }
    }
    //ERROR Response
    public class Error{
        @AuraEnabled
        public String  	code 	{get; set;}
        @AuraEnabled
        public String 	message {get; set;}
        @AuraEnabled
        public String 	cid 	{get; set;}
        
        public Error(){
            code 	= null;
            message = null;
            cid 	= null;
        }
    } 
      
    //GET WS
    @AuraEnabled
    public static AdjustmentsGETResponse getStatus3(String idCase) {                                                      
        TEST_cls_adjustmentsWS.AdjustmentsGETResponse response = TEST_cls_adjustmentsWS.AdjustmentsWS_GET(idCase);
        System.debug('getStatus3 response: ' + response);
        AdjustmentsGETResponse response2 = new AdjustmentsGETResponse();
        if(response!=null){
            response2 = (AdjustmentsGETResponse)JSON.deserialize(JSON.serialize(response), AdjustmentsGETResponse.class);
        }
        return response2;
    }
    
    //PATCH WS
    @AuraEnabled
    public static AdjustmentsPATCHResponse updateStatus3(String idCase, String status) {                                                      
        TEST_cls_adjustmentsWS.AdjustmentsPATCHResponse response = TEST_cls_adjustmentsWS.AdjustmentsWS_PATCH(idCase,status);
        System.debug('updateStatus3 response: ' + response);
        AdjustmentsPATCHResponse response2 = new AdjustmentsPATCHResponse();
        if(response!=null){
            response2 = (AdjustmentsPATCHResponse)JSON.deserialize(JSON.serialize(response), AdjustmentsPATCHResponse.class);
        }
        return response2;
    }

}