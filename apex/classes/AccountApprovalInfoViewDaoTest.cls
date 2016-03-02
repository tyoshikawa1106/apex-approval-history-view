@isTest
private class AccountApprovalInfoViewDaoTest {

    private static AccountApprovalInfoViewDao dao = new AccountApprovalInfoViewDao();
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * 承認履歴情報取得(ProcessInstance)
     * 値なし
     */
    static testMethod void getProcessInstancesTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            String targetObjectId = '';
            List<ProcessInstance> results = dao.getProcessInstances(targetObjectId);

            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * 承認履歴情報取得(ProcessInstance)
     * 値あり
     */
    static testMethod void getProcessInstancesTest2() {
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

            Test.startTest();

            String targetObjectId = account.Id;
            List<ProcessInstance> results = dao.getProcessInstances(targetObjectId);

            Test.stopTest();

            System.assertEquals(results.size(), 1);
        }
    }
}