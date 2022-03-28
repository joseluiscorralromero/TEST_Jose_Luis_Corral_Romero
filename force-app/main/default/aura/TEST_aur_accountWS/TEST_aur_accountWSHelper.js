({
    doInitHelper : function(component,event) {      
        var statusList = [ 
            { value: 'true', label: 'Yes'},
            { value: 'false', label: 'No'}
        ]
        component.set("v.statusList", statusList);
        component.set("v.targetStatus", 'true');  
    },
    
    getAccount2 : function(component,event) {
        var action = component.get("c.getAccount3"); 
        action.setParams({idAccount : component.get("v.recordId"),
                          withBalanceQuery : component.get("v.targetStatus")});
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getStatus2 state: '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('getStatus2 result: '+JSON.stringify(result));
                if(result.code == 200){
                    component.set('v.accountWraper', result);
                    component.set('v.iban', result.accountTransactionResponse[0].iban);
                    component.set('v.accountStatus', result.accountTransactionResponse[0].accountStatus);
                    component.set('v.product', result.accountTransactionResponse[0].product);
                    component.set('v.transactions', result.accountTransactionResponse[0].transactions);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Ha habido un error, consulte a un Administrador.',
                        duration:' 10000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
    
});