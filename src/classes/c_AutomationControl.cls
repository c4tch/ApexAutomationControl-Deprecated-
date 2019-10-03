/**
 @Name: c_AutomationControl.cls
 @TestedBy: Implementing in a test class
 @Description:
    Control Code flow execution from Custom Metadata (c_Automation__mtd)
    Uses String tokens (field is based on 'Automation Control Name' in the UI, and not the record label)
    
    An extension is included in this package for the Kevin O'Hara TriggerHandler framework where it expects setting "Triggers" for global control of trigger execution.
@History
  VERSION     AUTHOR           DATE            DETAIL
  1.0         Matt Evans       7/12/2018       Draft - A generic context and a basic factory automation for object creation
*/

public without sharing class c_AutomationControl {
    static Set<String> disabledAutomation;

    public static Boolean isDisabled(String automationControlName) {
        getDisabledSettings();
        return disabledAutomation.contains(automationControlName);
    }

    public static Boolean doNotFireTriggers() {
        getDisabledSettings();
        return disabledAutomation.contains('Triggers');
    }

    static void getDisabledSettings()
    {
        if (disabledAutomation==null)
        {
            disabledAutomation = new Set<String>();
            for (c_Automation__mdt d : [Select MasterLabel, DeveloperName,
                                Disable__c
                                FROM c_Automation__mdt
                                WHERE Disable__c = TRUE limit 999]){
                disabledAutomation.add(d.DeveloperName);
            }
        }
    }
}