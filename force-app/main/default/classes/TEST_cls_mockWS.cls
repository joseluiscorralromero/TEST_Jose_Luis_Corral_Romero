global class TEST_cls_mockWS implements HttpCalloutMock{
    
    global static HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //Token:
        if(req.getEndpoint() == 'http://api.example.com/salesforce/oauth/token' 
           && req.getMethod() == 'POST'){
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"accessToken": "stringAccessTokenExample",'+
                        '"expiresIn": 10000,'+
                        '"inactiveTime": 0}');
        	res.setStatusCode(200);
        } 
        //Account:
        if(req.getEndpoint().startsWith('https://api.example/accounts/v1/transactions/') 
           && req.getMethod() == 'GET'){
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('[{"iban": "ES4700759339324669344918",'+
                        '"accountStatus": "enabled",'+
                        '"product": "current",'+
                        '"transactions": ['+
                            '{"resourceId": "1234567890",'+
                            '"name": "Supermarket",'+
                            '"balanceType": "closingBooked",'+
                            '"amount": '+
                                '{"amount": "215",'+
                                '"currency0": "EUR"},'+
                            '"transactionDate": "2020-04-25T15:30:35.035Z"}'+
                        ']}]');
        	res.setStatusCode(200);
        }
        //Adjustments:
        if(req.getEndpoint() == 'https://api.example.com/adjustments/v1/adjustments' 
           && req.getMethod() == 'POST'){
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"adjustmentId": "182315c3-2913-4a19-9cae-c99784270889"}');
        	res.setStatusCode(200);
        }
        if(req.getEndpoint().startsWith('https://api.example.com/adjustments/v1/adjustments') 
           && req.getMethod() == 'GET'){
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('[{"adjustmentId": "182315c3-2913-4a19-9cae-c99784270889",'+
                        '"adjustmentStatus": "IN_PROGRESS"}]');
        	res.setStatusCode(200);
        }
        if(req.getEndpoint().startsWith('https://api.example.com/adjustments/v1/adjustments') 
           && req.getMethod() == 'PATCH'){
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"authorizationGroup": "MANAGER"}');
        	res.setStatusCode(200);
        }
        return res;
    }
    
}