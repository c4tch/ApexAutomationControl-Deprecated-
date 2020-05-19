## Automation Control pattern for Salesforce Lightning Platform

Automation for validation rules, process builder and triggers can be managed from the c_Automation__mtd custom metadata type. Automation control is the process of managing any automation on the platform from a central location (a custom metadata object).

Why not custom settings? Why not Custom Permissions?
Well first, Custom settings are excellent, they offer hierachial functionality (varied values based on Profile and User), however to create a new scope to control you have to create a new field in the custom setting object, or a new custom setting object and migration to production is a pain, so is testing. 

Custom Permissions are an excellent alternative, and in my currenty projects I'm actually going to try using these instead.

Syntax for formula (in *validation rules* etc.) to check a custom metadata type is $CustomMetadata.CustomMetadataTypeAPIName.RecordAPIName.FieldAPIName

For this therefore use *$c_Automation__mtd.[Automation Control Name].Disable__c*

[Image: image.png]

Disabling of all triggers is hard wired into the Trigger Framework. For individual trigger handlers or domain manager classes, a line of code should be added. For trigger handers, each class has a value TRIGGER_NAME. The Automation Control Name shoudl have the same token. For manager classes, a free text string is ok.

Example: All triggers
The trigger framework (Kevin O'Hara's trigger framework is budled with this code) has this hard wired in to turn off ALL triggers. 

Toggling the setting *Triggers* will disable ALL triggers from firing.

Example: Trigger Handlers
The metadata has a setting for the *AccountTriggerHandler*. The handler class of the same name shows:

```Apex
public with sharing class AccountTriggerHandler extends c_TriggerHandler {
    private final static string TRIGGER_NAME = 'AccountTriggerHandler';

    /**
    * Trigger DML
    **/
    public override void beforeInsert() {
        // Manage execution by TRIGGER_NAME in automation control. 
        // - To add an option, append the trigger name to the custom metadata c_Automation__mtd
        if (c_AutomationControl.isDisabled(TRIGGER_NAME)) return;
```

Example: Domain Manager
Above is a setting for the Sales cloud Account Manager class, with a speciffic action ‘TriggerAction’ appended to the end so we can understrand what its going to control. The code is like this:

```Apex
public with sharing class c_AccountManager {
    /**
    * Trigger DML processes for this domain
    **/
    public static void beforeInsert(Account[] LSC_Accounts) {
        // Prevent the method from firing if it has been disabled
        if (c_AutomationControl.isDisabled('c_AccountManager_TriggerAction')) return;
```
etc. etc.


