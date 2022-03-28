public class TEST_cls_accountWS { 
    
    //GET Response
    public class AccountResponse{
        public List<accountTransactionList> accountTransactionResponse 	= null; 
        public Error 						Error 						= null;
        public integer 						code 						= 0; 
    } 
    public class accountTransactionList{
        public String  					iban 			= null; //"[A-Z]{2,2}[0-9]{2,2}[a-zA-Z0-9]{1,30}" 
        public String 					accountStatus 	= null; //"enabled","deleted","blocked"
        public String 					product 		= null; //"current","saving"
        public List<transactionDetails> transactions 	= null;
    } 
    public class transactionDetails{
        public String resourceId 		= null; //Ej: "1234567890"
        public String name 				= null; //"maxLength": 35
        public String balanceType 		= null; //"closingBooked","expected","hold"
        public amount amount 			= null; 
        public String transactionDate 	= null; //Ej: "2020-04-25T15:30:35.035Z"
    } 
    public class amount{
        public String currency0 = null; //"[A-Z]{3}"
        public String amount 	= null; //"-?[0-9]{1,14}(\\.[0-9]{1,3})?"
    }
    //ERROR Response
    public class Error{
        public String code 		= null; //Ej: "accounts.error.invalid.input"
        public String message 	= null; //Ej: "The request does not contain valid data"
        public String cid 		= null; //Ej: "0123456789abcdef"
    } 

    //GET WS
    public static AccountResponse AccountWS(String idAccount, String withBalanceQuery){ //withBalanceQuery: boolean => true/false
        AccountResponse AccountResponseWrapper = new AccountResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Account currentAccount = [select Id, TEST_fld_accountId__c from Account where Id =:idAccount];
        String customerId = currentAccount.TEST_fld_accountId__c;
        String endPoint = 'https://api.example/accounts/v1/transactions/'+customerId;
        if (withBalanceQuery!=null){
            endPoint= endPoint+'?withBalanceQuery='+withBalanceQuery;
        }
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
        String xRequestId = genRandString(8)+'-'+genRandString(4)+'-'+genRandString(4)+'-'+genRandString(4)+'-'+genRandString(12);
        req.setHeader('X-Request-ID', xRequestId); //ID of the request, unique to the call, as determined by the initiating party.
        req.setTimeout(10000);
        //HTTPResponse res = http.send(req);
        HTTPResponse res = TEST_cls_mockWS.respond(req);
        String respuesta = res.getBody();
        System.debug('respuesta: ' + respuesta);
        AccountResponseWrapper.code = res.getStatusCode();
        if(res.getStatusCode() == 200){
            List<accountTransactionList> accountTransactionResponseWrapper = new List<accountTransactionList>();
            accountTransactionResponseWrapper = (List<accountTransactionList>) JSON.deserializeStrict(respuesta, List<accountTransactionList>.class);
            AccountResponseWrapper.accountTransactionResponse = accountTransactionResponseWrapper;
            System.debug('accountTransactionResponseWrapper: ' + accountTransactionResponseWrapper);
        }
        else if(res.getStatusCode() == 404){
            Error ErrorWrapper = new Error();
            ErrorWrapper = (Error) JSON.deserializeStrict(respuesta, Error.class);
            AccountResponseWrapper.Error = ErrorWrapper;
            System.debug('ErrorWrapper: ' + ErrorWrapper);
        }
        return AccountResponseWrapper;
    }
    
    //Generate Random String
    public static String genRandString(Integer len) {
        final String chars = '0123456789abcdef';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
}