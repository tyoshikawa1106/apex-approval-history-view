@isTest
private class AccountApprovalInfoViewHelperTest {

    private static AccountApprovalInfoViewHelper helper = new AccountApprovalInfoViewHelper();
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * 承認履歴情報取得
     * 値なし
     */
    static testMethod void getProcessInstanceHistoriesTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            List<ProcessInstance> processInstances = new List<ProcessInstance>();
            List<ProcessInstanceHistory> results = helper.getProcessInstanceHistories(processInstances);

            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }
}