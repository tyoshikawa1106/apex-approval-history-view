@isTest
private class ProcessInstanceInfoTest {

    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * コンストラクタ
     */
    static testMethod void ProcessInstanceInfoTest1() {
        System.runAs(testAdminUser) {

            Test.startTest();

            ProcessInstanceInfo cls = new ProcessInstanceInfo();

            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.completedDate), true);
            System.assertEquals(String.isEmpty(cls.stepStatus), true);
            System.assertEquals(String.isEmpty(cls.originalActorUser), true);
            System.assertEquals(String.isEmpty(cls.actorUser), true);
            System.assertEquals(String.isEmpty(cls.comment), true);
        }
    }

    /**
     * コンストラクタ
     */
    static testMethod void ProcessInstanceInfoTest2() {
        System.runAs(testAdminUser) {

            ProcessInstanceHistory history = new ProcessInstanceHistory();
            Map<Id, User> userMap = new Map<Id, User>();

            Test.startTest();

            ProcessInstanceInfo cls = new ProcessInstanceInfo(history, userMap);

            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.completedDate), true);
            System.assertEquals(String.isEmpty(cls.stepStatus), true);
            System.assertEquals(String.isEmpty(cls.originalActorUser), true);
            System.assertEquals(String.isEmpty(cls.actorUser), true);
            System.assertEquals(String.isEmpty(cls.comment), true);
        }
    }

    /**
     * 状況取得
     */
    static testMethod void getStepStatusTest1() {
        System.runAs(testAdminUser) {

            ProcessInstanceInfo cls = new ProcessInstanceInfo();

            Test.startTest();

            String result = cls.getStepStatus('Started');
            System.assertEquals(result, '申請済み');

            result = cls.getStepStatus('Approved');
            System.assertEquals(result, '承認済み');

            result = cls.getStepStatus('Pending');
            System.assertEquals(result, '未承認');

            result = cls.getStepStatus('Rejected');
            System.assertEquals(result, '却下');

            Test.stopTest();
        }
    }
}