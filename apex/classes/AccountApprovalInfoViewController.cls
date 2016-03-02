public with sharing class AccountApprovalInfoViewController {
    
    private AccountApprovalInfoViewHelper helper = new AccountApprovalInfoViewHelper();
    private AccountApprovalInfoViewDao dao = new AccountApprovalInfoViewDao();
    
    // 承認履歴情報
    public List<ProcessInstanceHistory> processInstanceHistories {get; set;}
    
    /**
     * コンストラクタ
     */
    public AccountApprovalInfoViewController(ApexPages.StandardController stdController) {
        try {
            // 承認履歴情報初期化
            this.processInstanceHistories = new List<ProcessInstanceHistory>();
            // 取引先ID
            String recordId = stdController.getId();
            // processInstance取得
            List<ProcessInstance> processInstances = dao.getProcessInstances(recordId);
            // 承認履歴情報取得
            this.processInstanceHistories = helper.getProcessInstanceHistories(processInstances);
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            return;
        }
    }
}