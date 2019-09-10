/**
 @Name: c_AutomationControl_Test.cls
 @Tests: c_AutomationControl
 @Description:
    Checks fundamental settings have not been removed an that code methods are working
@History
  VERSION     AUTHOR           DATE            DETAIL
  1.0         Matt Evans       7/12/2018       Initial commit
*/

@IsTest
private with sharing class c_AutomationControl_Test {
    @IsTest
    static void checkFundamentalCustomMetaDataTypes() {
        c_Automation__mdt[] d = [Select MasterLabel, DeveloperName,
                                    Disable__c
                                    FROM c_Automation__mdt
                                    WHERE DeveloperName = 'Triggers'];
        System.Assert(!d.IsEmpty(), 'Setting name "Triggers" is missing from Custom Meta Data "Automation Control". This is a mandatory setting. Add back!');
    }

    @IsTest
    static void codeCoverageAsWeCannotTestMetadataAPI() {
        c_AutomationControl.doNotFireTriggers();
        c_AutomationControl.isDisabled('Triggers');
    }
}