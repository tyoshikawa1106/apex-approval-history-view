public with sharing class AccountApprovalInfoViewController {
    
    private AccountApprovalInfoViewHelper helper = new AccountApprovalInfoViewHelper();
    private AccountApprovalInfoViewDao dao = new AccountApprovalInfoViewDao();
    
    // 承認履歴情報
    public List<ProcessInstanceInfo> processInstanceInfoList {get; set;}
    
    /**
     * コンストラクタ
     */
    public AccountApprovalInfoViewController(ApexPages.StandardController stdController) {
        try {
            // 承認履歴情報初期化
            this.processInstanceInfoList = new List<ProcessInstanceInfo>();
            // 取引先ID
            String recordId = stdController.getId();
            // processInstance取得
            List<ProcessInstance> processInstances = dao.getProcessInstances(recordId);
            // ユーザID情報取得
            Set<Id> userIds = helper.getActorIds(processInstances);
            // ユーザ情報取得
            List<User> users = dao.getActorUsers(userIds);
            // ユーザマップ取得
            Map<Id, User> userMap = new Map<Id, User>(users);
            // 戻り値取得
            this.processInstanceInfoList = helper.getProcessInstanceInfoList(processInstances, userMap);
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            return;
        }        
    }

}