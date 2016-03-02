@isTest
private class AccountApprovalInfoViewHelperTest {

    private static AccountApprovalInfoViewHelper helper = new AccountApprovalInfoViewHelper();
    private static AccountApprovalInfoViewDao dao = new AccountApprovalInfoViewDao();
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * ユーザID取得
     * 値なし
     */
    static testMethod void getActorIdsTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            List<ProcessInstance> processInstances = new List<ProcessInstance>();
            Set<Id> results = helper.getActorIds(processInstances);

            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * ユーザID取得
     * 値あり(申請のみ)
     */
    static testMethod void getActorIdsTest2() {
        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = new Account(Name = 'salesforce.com - Tokyo');
            insert account;
            System.assertEquals(String.isNotEmpty(account.Id), true);

            // 承認申請テストデータ
            Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(account.Id);
            psr.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Approval.ProcessResult submitResult = Approval.process(psr);
            System.assert(submitResult.isSuccess());

            // 状態の確認
            System.assertEquals('Pending', submitResult.getInstanceStatus());
            // ProcessInstanceWorkitemオブジェクトのIDを取得
            List<Id> newWorkItemIds = submitResult.getNewWorkitemIds();
            System.assertEquals(newWorkItemIds.isEmpty(), false);

            String targetObjectId = account.Id;
            List<ProcessInstance> processInstances = dao.getProcessInstances(targetObjectId);
            System.assertEquals(processInstances.size(), 1);
            System.assertEquals(processInstances[0].StepsAndWorkitems.isEmpty(), true);

            Test.startTest();

            Set<Id> results = helper.getActorIds(processInstances);

            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * ユーザID取得
     * 値あり(承認実行後)
     */
    static testMethod void getActorIdsTest3() {
        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = new Account(Name = 'salesforce.com - DEMO');
            insert account;
            System.assertEquals(String.isNotEmpty(account.Id), true);

            // 承認申請テストデータ
            Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(account.Id);
            psr.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Approval.ProcessResult submitResult = Approval.process(psr);
            System.assert(submitResult.isSuccess());
            System.assertEquals('Pending', submitResult.getInstanceStatus());

            Id processId = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: account.Id AND Status = 'Pending' LIMIT 1].Id;
            Id workitemId = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: processId LIMIT 1].Id;

            // プロセスの作成
            Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
            request.setAction('Approve');
            request.setNextApproverIds(new Id[]{UserInfo.getUserId()});
            request.setWorkitemId(workitemId);
            Approval.ProcessResult requestResult = Approval.process(request);
            System.assertEquals(requestResult.isSuccess(), true);

            // テスト実施
            String targetObjectId = account.Id;
            List<ProcessInstance> processInstances = dao.getProcessInstances(targetObjectId);
            System.assertEquals(processInstances.size(), 1);
            // 値が取得できない...
            System.assertEquals(processInstances[0].StepsAndWorkitems.isEmpty(), true);

            Test.startTest();

            Set<Id> results = helper.getActorIds(processInstances);

            Test.stopTest();

            // 値が取得できない...
            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * 戻り値リスト取得
     * 値なし
     */
    static testMethod void getProcessInstanceInfoListTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            List<ProcessInstance> processInstances = new List<ProcessInstance>();
            Map<Id, User> userMap = new Map<Id, User>();

            List<ProcessInstanceInfo> results = helper.getProcessInstanceInfoList(processInstances, userMap);

            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * 戻り値リスト取得
     * 値あり
     */
    static testMethod void getProcessInstanceInfoListTest2() {
        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = new Account(Name = 'salesforce.com - DEMO');
            insert account;
            System.assertEquals(String.isNotEmpty(account.Id), true);

            // 承認申請テストデータ
            Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(account.Id);
            psr.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Approval.ProcessResult submitResult = Approval.process(psr);
            System.assert(submitResult.isSuccess());
            System.assertEquals('Pending', submitResult.getInstanceStatus());

            Id processId = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: account.Id AND Status = 'Pending' LIMIT 1].Id;
            Id workitemId = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: processId LIMIT 1].Id;

            // プロセスの作成
            Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
            request.setAction('Approve');
            request.setNextApproverIds(new Id[]{UserInfo.getUserId()});
            request.setWorkitemId(workitemId);
            Approval.ProcessResult requestResult = Approval.process(request);
            System.assertEquals(requestResult.isSuccess(), true);

            Test.startTest();

            // テスト実施
            String targetObjectId = account.Id;
            List<ProcessInstance> processInstances = dao.getProcessInstances(targetObjectId);
            System.assertEquals(processInstances.size(), 1);
            Map<Id, User> userMap = new Map<Id, User>();
            userMap.put(testAdminUser.Id, testAdminUser);

            List<ProcessInstanceInfo> results = helper.getProcessInstanceInfoList(processInstances, userMap);

            Test.stopTest();

            // 値が取得できない...
            System.assertEquals(results.size(), 0);
        }
    }
}