/**
 @Name: AccountTriggerHandler.cls
 @TestedBy: ... Untested, sample class only...
 @Other classes used: c_TriggerHandler, ...
 @Description: Description:
    1. Example blocking the handler from firing using the automation framework
@Useage
    USE BYPASSES - Placing code between the bypasses ensures the code block will not get refired if another process fires this during the transaction:
    In each method, filter the list of inbound trigger data and decide which Manager class to call
    The filters should avoid having the same record processed by more than one handler.
    Lists are more efficient than MAPs (x3) so use those if itterating where possible.
    Call each domain handler with their respective account records. 
 @History
  VERSION     AUTHOR           DATE            DETAIL
  1.0         Matt Evans       28/8/2019       EXample code, to allow the package to compile
 */

public with sharing class AccountTriggerHandler extends c_TriggerHandler {
    private final static string TRIGGER_NAME = 'AccountTriggerHandler';

    /**
    * Trigger DML
    **/
    public override void beforeInsert() {
        // Manage execution by TRIGGER_NAME in automation control. 
        // - To add an option, append the trigger name to the custom metadata c_Automation__mtd
        if (c_AutomationControl.isDisabled(TRIGGER_NAME)) return;

        // BYPASS activated to prevent trigger re-firing
        c_TriggerHandler.bypass(TRIGGER_NAME);

        // Filter the records to be processed by domain manager
        List<Account> my_AccountList = new List<Account>();
        for (Account a : (List<Account>)Trigger.new) {
            // Example: if (a.RecordTypeName = 'Prospect') my_AccountList.add(a);
        }

        // Call each domain manager with their respective account records:
        // - Sales Cloud
        // my_AccountManager.beforeInsert(my_AccountList); // Pass Maps if required, but try to use lists as they are faster

        c_TriggerHandler.clearBypass(TRIGGER_NAME);

        // Code to fire every time the trigger runs goes after the bypass

    }
    //*/
}