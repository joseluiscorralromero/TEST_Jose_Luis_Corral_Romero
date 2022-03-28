({
    doInitHelper : function(component,event) {      
        var statusList = [ 
            { value: 'IN_PROGRESS', label: 'In Progress'},
            { value: 'PENDING_ACCEPTED', label: 'Pending Accepted'},
            { value: 'CLOSED', label: 'Closed'}
        ]
        component.set("v.statusList", statusList);
        component.set("v.targetStatus", 'IN_PROGRESS');  
    },
    
    getStatus2 : function(component,event) {
        var action = component.get("c.getStatus3"); 
        action.setParams({idCase : component.get("v.recordId")});
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getStatus2 state: '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('getStatus2 result: '+JSON.stringify(result));
                if(result.code == 200){
                    component.set('v.currentStatus', result.adjustmentsResponse[0].adjustmentStatus);
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
    },
    
    updateStatus2 : function(component,event) {      
        var action = component.get("c.updateStatus3");
        action.setParams({idCase : component.get("v.recordId"),
                          status : component.get("v.targetStatus")});
        var self = this;
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('updateStatus2 state: '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('updateStatus2 result: '+JSON.stringify(result));
                if(result.code == 200){
                    component.set('v.authorizationGroup', result.authorizeResponse.authorizationGroup);
                }
                else if(result.code == 204){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Status change succesfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                	});
                    toastEvent.fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Something went wrong',
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