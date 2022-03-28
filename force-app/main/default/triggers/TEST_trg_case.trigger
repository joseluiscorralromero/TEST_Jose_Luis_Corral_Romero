trigger TEST_trg_case on Case (after insert, after update) {
    
    if(Trigger.isInsert && Trigger.isAfter){
        TEST_cls_caseHelper.afterInsertMethod(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        TEST_cls_caseHelper.afterUpdateMethod(Trigger.new);
    }

}