public class TEST_cls_caseHelper {

    public static void afterInsertMethod(List<Case> triggerNew){
        //POST Adjustments
        TEST_cls_adjustmentsWS.AdjustmentsPOSTResponse AdjustmentsPOSTResponseWrapper = new TEST_cls_adjustmentsWS.AdjustmentsPOSTResponse();
        for(Case cse : triggerNew){ //things in a loop cause WS cant be bulkified
            if(cse.TEST_fld_currency__c != null && cse.TEST_fld_amount__c != null){
                try {
                    AdjustmentsPOSTResponseWrapper = TEST_cls_adjustmentsWS.AdjustmentsWS_POST(cse.Id);
                    if(AdjustmentsPOSTResponseWrapper.code == 200){
                        Case cseQry = [select Id, TEST_fld_adjustmentId__c from Case where Id = :cse.Id];
                        cseQry.TEST_fld_adjustmentId__c = AdjustmentsPOSTResponseWrapper.createAdjustmentResponse.adjustmentId;
                        update cseQry;
                    }
                }
                catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
        }
    }
    
    public static void afterUpdateMethod(List<Case> triggerNew){
        //POST Adjustments si el caso no tiene aún adjustmentId
        TEST_cls_adjustmentsWS.AdjustmentsPOSTResponse AdjustmentsPOSTResponseWrapper = new TEST_cls_adjustmentsWS.AdjustmentsPOSTResponse();
        for(Case cse : triggerNew){ //things in a loop cause WS cant be bulkified
            if(cse.TEST_fld_adjustmentId__c == null && cse.TEST_fld_currency__c != null && cse.TEST_fld_amount__c != null){
                try {
                    AdjustmentsPOSTResponseWrapper = TEST_cls_adjustmentsWS.AdjustmentsWS_POST(cse.Id);
                    if(AdjustmentsPOSTResponseWrapper.code == 200){
                        Case cseQry = [select Id, TEST_fld_adjustmentId__c from Case where Id = :cse.Id];
                        cseQry.TEST_fld_adjustmentId__c = AdjustmentsPOSTResponseWrapper.createAdjustmentResponse.adjustmentId;
                        update cseQry;
                    }
                }
                catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
        }
    }
        
}