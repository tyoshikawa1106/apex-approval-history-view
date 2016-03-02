@isTest
private class AccountApprovalInfoViewControllerTest {

    private static AccountApprovalInfoViewDao dao = new AccountApprovalInfoViewDao();
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * コンストラクタ
     */
    static testMethod void AccountApprovalInfoViewControllerTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            AccountApprovalInfoViewController cls = new AccountApprovalInfoViewController(new ApexPages.StandardController(new Account()));

            Test.stopTest();

            System.assertEquals(cls.processInstanceHistories.size(), 0);
        }
    }
}