public with sharing class AccountApprovalInfoViewHelper {
    
    /**
     * コンストラクタ
     */
    public AccountApprovalInfoViewHelper() {
        
    }
    
    /**
     * ユーザID取得
     */
    public Set<Id> getActorIds(List<ProcessInstance> processInstances) {
        Set<Id> userIds = new Set<Id>();
        for (ProcessInstance p : processInstances) {
            for (ProcessInstanceHistory history : p.StepsAndWorkitems) {
                userIds.add(history.ActorId);
                userIds.add(history.OriginalActorId);
            }
        }
        return userIds;
    }
    
    /**
     * 戻り値リスト取得
     */
    public List<ProcessInstanceInfo> getProcessInstanceInfoList(List<ProcessInstance> processInstances, Map<Id, User> userMap) {
        List<ProcessInstanceInfo> results = new List<ProcessInstanceInfo>();
        for (ProcessInstance p : processInstances) {
            for (ProcessInstanceHistory history : p.StepsAndWorkitems) {
                results.add(new ProcessInstanceInfo(history, userMap));
            }
        }
        return results;
    }
}