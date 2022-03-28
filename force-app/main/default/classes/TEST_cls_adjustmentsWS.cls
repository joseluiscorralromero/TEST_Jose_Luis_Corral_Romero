public class TEST_cls_adjustmentsWS { 
    
    //POST Response
    public class AdjustmentsPOSTResponse{
        public createAdjustmentResponse  	createAdjustmentResponse 	= null; 
        public Error 						Error 						= null;
        public integer 						code 						= 0; 
    }
    public class createAdjustmentResponse{
        public String adjustmentId = null; //"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
    }
    //GET Response
    public class AdjustmentsGETResponse{
        public List<adjustment>  	adjustmentsResponse = null; 
        public Error 				Error 				= null;
        public integer 				code 				= 0; 
    } 
    public class adjustment{
        public String  	adjustmentId 		= null; //"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
        public String 	adjustmentStatus 	= null; //"IN_PROGRESS","PENDING_ACCEPTED","CLOSED"
    }  
    //PATCH Response
    public class AdjustmentsPATCHResponse{
        public authorizeResponse  	authorizeResponse 	= null; 
        public Error 				Error 				= null;
        public integer 				code 				= 0; 
    }
    public class authorizeResponse{
        public String authorizationGroup = null; //Ej: "Manager"
    }
    //ERROR Response
    public class Error{
        public String code 		= null; //Ej: "adjustments.error.invalid.input"
        public String message 	= null; //Ej: "The request does not contain valid data"
        public String cid 		= null; //Ej: "0123456789abcdef"
    }
 	//POST Request
    public class adjustmentBodyRequest{
        public String accountId 		= null; //"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
        public amount amount	 		= null;
        public String adjustmentStatus 	= null; //"IN_PROGRESS","PENDING_ACCEPTED","CLOSED"
    }
 	public class amount {
        public String currency0 = null; //"[A-Z]{3}"
        public String amount 	= null; //"-?[0-9]{1,14}(\\.[0-9]{1,3})?"
    }    
    
    //POST WS
    public static AdjustmentsPOSTResponse AdjustmentsWS_POST(String idCase){   
        AdjustmentsPOSTResponse AdjustmentsPOSTResponseWrapper = new AdjustmentsPOSTResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endPoint = 'https://api.example.com/adjustments/v1/adjustments';
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        TEST_cls_crmToken.CrmTokenResponse CrmTokenResponse = new TEST_cls_crmToken.CrmTokenResponse();
        try {
            CrmTokenResponse = TEST_cls_crmToken.CrmTokenWS();
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        String token = '';
        if(CrmTokenResponse!=null && CrmTokenResponse.AccessTokenResponse!=null && CrmTokenResponse.AccessTokenResponse.accessToken!=null){
        	token = CrmTokenResponse.AccessTokenResponse.accessToken;
        }
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        Case currentCase = [select Id, AccountId, Account.TEST_fld_accountId__c, TEST_fld_currency__c, TEST_fld_amount__c, TEST_fld_adjustmentId__c from Case where Id =:idCase];
        String accountId = currentCase.Account.TEST_fld_accountId__c;
        adjustmentBodyRequest adjustmentBodyRequestWrap = new adjustmentBodyRequest(); 
        adjustmentBodyRequestWrap.accountId = accountId;
        amount amountWrap = new amount();
        amountWrap.amount = currentCase.TEST_fld_amount__c;
        amountWrap.currency0 = currentCase.TEST_fld_currency__c;
        adjustmentBodyRequestWrap.amount = amountWrap;
        if(math.abs(Integer.valueOf(amountWrap.amount))<1000){
            adjustmentBodyRequestWrap.adjustmentStatus = 'CLOSED';
        }
        String body = JSON.serialize(adjustmentBodyRequestWrap);
        req.setBody(body);
        req.setTimeout(10000);
        //HTTPResponse res = http.send(req);
        HTTPResponse res = TEST_cls_mockWS.respond(req);
        String respuesta = res.getBody();
        System.debug('respuesta: ' + respuesta);
        AdjustmentsPOSTResponseWrapper.code = res.getStatusCode();
        if(res.getStatusCode() == 200){
            createAdjustmentResponse createAdjustmentResponseWrapper = new createAdjustmentResponse();
            createAdjustmentResponseWrapper = (createAdjustmentResponse) JSON.deserializeStrict(respuesta, createAdjustmentResponse.class);
            AdjustmentsPOSTResponseWrapper.createAdjustmentResponse = createAdjustmentResponseWrapper;
            System.debug('createAdjustmentResponseWrapper: ' + createAdjustmentResponseWrapper);
        }
        else if(res.getStatusCode() == 400){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AdjustmentsPOSTResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        }
        else if(res.getStatusCode() == 401){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AdjustmentsPOSTResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        }
        System.debug('AdjustmentsPOSTResponseWrapper: ' + AdjustmentsPOSTResponseWrapper);
        return AdjustmentsPOSTResponseWrapper;
    }
    
    //GET WS
    public static AdjustmentsGETResponse AdjustmentsWS_GET(String idCase){   
        AdjustmentsGETResponse AdjustmentsGETResponseWrapper = new AdjustmentsGETResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endPoint = 'https://api.example.com/adjustments/v1/adjustments';
        Case currentCase = [select Id, AccountId, Account.TEST_fld_accountId__c, TEST_fld_currency__c, TEST_fld_amount__c, TEST_fld_adjustmentId__c from Case where Id =:idCase];
        String adjustmentId = currentCase.TEST_fld_adjustmentId__c;
        endPoint= endPoint+'?adjustmentId='+adjustmentId;
        String accountId = currentCase.Account.TEST_fld_accountId__c;
		endPoint= endPoint+'/&accountId='+accountId;
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        TEST_cls_crmToken.CrmTokenResponse CrmTokenResponse = new TEST_cls_crmToken.CrmTokenResponse();
        try {
            CrmTokenResponse = TEST_cls_crmToken.CrmTokenWS();
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        String token = '';
        if(CrmTokenResponse!=null && CrmTokenResponse.AccessTokenResponse!=null && CrmTokenResponse.AccessTokenResponse.accessToken!=null){
        	token = CrmTokenResponse.AccessTokenResponse.accessToken;
        }
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setTimeout(10000);
        //HTTPResponse res = http.send(req);
        HTTPResponse res = TEST_cls_mockWS.respond(req);
        String respuesta = res.getBody();
        System.debug('respuesta: ' + respuesta);
        AdjustmentsGETResponseWrapper.code = res.getStatusCode();
        if(res.getStatusCode() == 200){
            List<adjustment> adjustmentWrapperList = new List<adjustment>();
            adjustmentWrapperList = (List<adjustment>) JSON.deserializeStrict(respuesta, List<adjustment>.class);
            AdjustmentsGETResponseWrapper.adjustmentsResponse = adjustmentWrapperList;
            System.debug('adjustmentWrapperList: ' + adjustmentWrapperList);
        }
        else if(res.getStatusCode() == 404){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AdjustmentsGETResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        } 
        System.debug('AdjustmentsGETResponseWrapper: ' + AdjustmentsGETResponseWrapper);
        return AdjustmentsGETResponseWrapper;
    }
    
    //PATCH WS
    public static AdjustmentsPATCHResponse AdjustmentsWS_PATCH(String idCase, String status){ //status: "IN_PROGRESS","PENDING_ACCEPTED","CLOSED"
        AdjustmentsPATCHResponse AdjustmentsPATCHResponseWrapper = new AdjustmentsPATCHResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Case currentCase = [select Id, AccountId, Account.TEST_fld_accountId__c, TEST_fld_currency__c, TEST_fld_amount__c, TEST_fld_adjustmentId__c from Case where Id =:idCase];
        String adjustmentId = currentCase.TEST_fld_adjustmentId__c;
        String endPoint = 'https://api.example.com/adjustments/v1/adjustments/'+adjustmentId+'/status/'+status;
        req.setEndpoint(endPoint);
        req.setMethod('PATCH');
        req.setTimeout(10000);
        //HTTPResponse res = http.send(req);
        HTTPResponse res = TEST_cls_mockWS.respond(req);
        String respuesta = res.getBody();
        System.debug('respuesta: ' + respuesta);
        AdjustmentsPATCHResponseWrapper.code = res.getStatusCode();
        if(res.getStatusCode() == 200){
            authorizeResponse authorizeResponseWrapper = new authorizeResponse();
            authorizeResponseWrapper = (authorizeResponse) JSON.deserializeStrict(respuesta, authorizeResponse.class);
            AdjustmentsPATCHResponseWrapper.authorizeResponse = authorizeResponseWrapper;
            System.debug('authorizeResponseWrapper: ' + authorizeResponseWrapper);
        }
        else if(res.getStatusCode() == 204){
            //Status change succesfully
        }
        else if(res.getStatusCode() == 404){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AdjustmentsPATCHResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        }
        else if(res.getStatusCode() == 422){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AdjustmentsPATCHResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        }
        System.debug('AdjustmentsPATCHResponseWrapper: ' + AdjustmentsPATCHResponseWrapper);
        return AdjustmentsPATCHResponseWrapper;
    }
    
}