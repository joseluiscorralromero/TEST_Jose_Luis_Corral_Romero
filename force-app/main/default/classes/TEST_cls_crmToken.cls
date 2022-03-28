public class TEST_cls_crmToken { 
    
    //POST RESPONSE
    public class CrmTokenResponse{
        public AccessTokenResponse  AccessTokenResponse = null; 
        public OauthError 			OauthError 			= null;
        public integer 				code 				= 0; 
    } 
    public class AccessTokenResponse{
        public String  accessToken 	= null; //Ej: "string"
        public Integer expiresIn 	= 0; 	//miliseconds?
        public Integer inactiveTime = 0; 	//miliseconds?
    } 
    //ERROR Response
    public class OauthError{
        public String error 			= null; //"invalid_request","invalid_grant","unauthorized","server_error","temporarily_unavailable"
        public String error_description = null; //Ej: "Authentication Failed"
    } 
    //POST REQUEST
    //JWT signed by client. Assumptions: Use any example certificate to sign the JWT. Token will be valid for 10 seconds. Set localhost as audience. 
    //Only token with the following claims are accepted: - operatorRole: 'AGENT', - operator: federationId of a crm user
    public class CrmAgentTokenRequest{
        public String token;
    }

    //POST WS
    public static CrmTokenResponse CrmTokenWS(){   
        CrmTokenResponse CrmTokenResponseWrapper = new CrmTokenResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.example.com/salesforce/oauth/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        CrmAgentTokenRequest CrmAgentTokenRequestWrapper = new CrmAgentTokenRequest();
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [select id, FederationIdentifier from User where id =: currentUserId];
        String federationId = currentUser.FederationIdentifier;
        CrmAgentTokenRequestWrapper.token = '{"operatorRole":"AGENT","operator":"'+federationId+'"}';
        String body = JSON.serialize(CrmAgentTokenRequestWrapper);
        req.setBody(body);
        req.setTimeout(10000);
        //HTTPResponse res = http.send(req);
        HTTPResponse res = TEST_cls_mockWS.respond(req);
        String respuesta = res.getBody();
        System.debug('respuesta: ' + respuesta);
        CrmTokenResponseWrapper.code = res.getStatusCode();
        if(res.getStatusCode() == 200){
            AccessTokenResponse AccessTokenResponseWrapper = new AccessTokenResponse();
            AccessTokenResponseWrapper = (AccessTokenResponse) JSON.deserializeStrict(respuesta, AccessTokenResponse.class);
            CrmTokenResponseWrapper.AccessTokenResponse = AccessTokenResponseWrapper;
            System.debug('AccessTokenResponseWrapper: ' + AccessTokenResponseWrapper);
        }
        else if(res.getStatusCode() == 400){
            OauthError OauthErrorWrapper = new OauthError();
            OauthErrorWrapper = (OauthError) JSON.deserializeStrict(respuesta, OauthError.class);
            CrmTokenResponseWrapper.OauthError = OauthErrorWrapper;
            System.debug('OauthErrorWrapper: ' + OauthErrorWrapper);
        }
        else if(res.getStatusCode() == 401){
            //Unauthorized
        }
        return CrmTokenResponseWrapper;
    }
    
}