public with sharing class AccountApprovalInfoViewDao {
    
    /**
     * コンストラクタ
     */
    public AccountApprovalInfoViewDao() {
        
    }
    
    /**
     * 承認履歴情報取得(ProcessInstance)
     */
    public List<ProcessInstance> getProcessInstances(String targetObjectId) {
        return [
            SELECT
                 Id
                ,CompletedDate
                ,LastActorId
                ,ProcessDefinitionId
                ,Status
                ,TargetObjectId
                ,(
                    SELECT 
                         Id
                        ,ActorId
                        ,Comments
                        ,IsPending
                        ,OriginalActorId
                        ,ProcessInstanceId
                        ,ProcessNodeId
                        ,StepStatus
                        ,TargetObjectId
                        ,CreatedDate
                    FROM
                        StepsAndWorkitems
                    ORDER BY CreatedDate DESC
                )
            FROM
                ProcessInstance
            WHERE
                TargetObjectId =: targetObjectId
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}