public with sharing class ProcessInstanceInfo {
    
    // 日付
    public String completedDate {get; set;}
    // 状況
    public String stepStatus {get; set;}
    // 割当先
    public String originalActorUser {get; set;}
    // 承認者
    public String actorUser {get; set;}
    // コメント
    public String comment {get; set;}
    
    /**
     * コンストラクタ
     */
    public ProcessInstanceInfo() {
        this.completedDate = '';
        this.stepStatus = '';
        this.originalActorUser = '';
        this.actorUser = '';
        this.comment = '';
    }
    
    /**
     * コンストラクタ
     */
    public ProcessInstanceInfo(ProcessInstanceHistory history, Map<Id, User> userMap) {
        // 日付
        if (history.CreatedDate != null) {
            this.completedDate = history.CreatedDate.format('yyyy/MM/dd HH:mm:ss', 'JST');
        }
        // 状況
        this.stepStatus = this.getStepStatus(history.StepStatus);
        // 割当先
        if (userMap.containsKey(history.OriginalActorId)) {
            this.originalActorUser = userMap.get(history.OriginalActorId).Name;
        }
        // 承認者
        if (userMap.containsKey(history.ActorId)) {
            this.actorUser = userMap.get(history.ActorId).Name;
        }
        // コメント
        this.comment = history.Comments;
    }
    
    /**
     * 状況取得
     */
    @TestVisible
    private String getStepStatus(String stepStatus) {
        if (stepStatus == 'Started') {
            return '申請済み';
        } else if (stepStatus == 'Approved') {
            return '承認済み';
        } else if (stepStatus == 'Pending') {
            return '未承認';
        } else if (stepStatus == 'Rejected') {
            return '却下';
        }

        return stepStatus;
    }
}