public class TEST_cls_account_cc {
    
    //GET Response
    public class AccountResponse{
        @AuraEnabled
        public List<accountTransactionList>  	accountTransactionResponse 	{get; set;}
        @AuraEnabled
        public Error 							Error 						{get; set;}
        @AuraEnabled
        public integer 							code 						{get; set;} 
        
        public AccountResponse(){
            accountTransactionResponse 	= null;
            Error 						= null;
            code 						= 0;
        }
    } 
    public class accountTransactionList{
        @AuraEnabled
        public String  					iban 			{get; set;}
        @AuraEnabled
        public String 					accountStatus	{get; set;}
        @AuraEnabled
        public String  					product 		{get; set;}
        @AuraEnabled
        public List<transactionDetails> transactions	{get; set;}
        
        public accountTransactionList(){
            iban 			= null;
            accountStatus 	= null;
            product 		= null;
            transactions 	= null;
        }
    }
    public class transactionDetails{
        @AuraEnabled
        public String  			resourceId 		{get; set;}
        @AuraEnabled
        public String 			name			{get; set;}
        @AuraEnabled
        public String  			balanceType 	{get; set;}
        @AuraEnabled
        public amount 			amount			{get; set;}
        @AuraEnabled
        public String  			transactionDate {get; set;}
        
        public transactionDetails(){
            resourceId 			= null;
            name 				= null;
            balanceType 		= null;
            amount 				= null;
            transactionDate 	= null;
        }
    }
    public class amount{
        @AuraEnabled
        public String  	currency0 	{get; set;}
        @AuraEnabled
        public String 	amount 		{get; set;}
        
        public amount(){
            currency0 	= null;
            amount 		= null;
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
    public static AccountResponse getAccount3(String idAccount, String withBalanceQuery) {  
        System.debug('getAccount3 idAccount: ' + idAccount+', withBalanceQuery: ' + withBalanceQuery);
        TEST_cls_accountWS.AccountResponse response = TEST_cls_accountWS.AccountWS(idAccount,withBalanceQuery);
        System.debug('getAccount3 response: ' + response);
        AccountResponse response2 = new AccountResponse();
        if(response!=null){
            response2 = (AccountResponse)JSON.deserialize(JSON.serialize(response), AccountResponse.class);
        }
        return response2;
    }

}