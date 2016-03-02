public with sharing class AccountApprovalInfoViewHelper {
    
    /**
     * コンストラクタ
     */
    public AccountApprovalInfoViewHelper() {
        
    }

    /**
     * 承認履歴情報取得
     */
    public List<ProcessInstanceHistory> getProcessInstanceHistories(List<ProcessInstance> processInstances) {
        List<ProcessInstanceHistory> processInstanceHistories = new List<ProcessInstanceHistory>();
        for (ProcessInstance p : processInstances) {
            processInstanceHistories.addAll(p.StepsAndWorkitems);
        }

        return processInstanceHistories;
    }
}