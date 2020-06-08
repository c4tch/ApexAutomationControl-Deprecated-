## Automation Control pattern for Salesforce Lightning Platform (DEPRECATED)
Why deprecated?
Well first, this was just a basic pattern so it's no skin of the proverbial shin to move to another solution. It still works but we found that using Custom Permnissions was more useful and more flexible as you could (1) deploy them (which you can't do with hierachial Custom Settings content - which was the main reason to use Custom Metadata over Custom Settings) and (2) assign periodicalyl using permission sets etc. (which was the main reason for using Custom Settings instead of Custom Metadata).

Therefore we end up with a check list: the framework should have a solution that...

1. Can apply to users based on profile / grouping
2. Can be deployed through the CI pipeline
3. Can be easily extended

Custom settings pass only (1)

Custom metadata passes (2) and (3) but for (1) it has a partial pass as the code can do this, and in the UI you get a long formula that can check any additional fields you add to the Custom Meta data

Custom Permissions + Permission Sets... Passes (1) (2) and (3)

So, DEPRECATED! Go check out Custom Permissions if you dont know them yet. Here is how I recommended to a recent client to use them:

> We can use custom permissions to be Permissive or Restrictive of a customisation depending on scenario. For automation control we shall use these as Restrictive. Custom Permissions are applied to Permission Sets which may be assigned to profiles, permission set groups or specific users. They can also be released as part of a release to production, which cannot be done with custom settings.

I defined the following Restrictive Permissions: 
> General: BypassValidationRules, BypassProcessBuilder, BypassTriggers, BypassFlows

> Use Case / Stream Specific*: BypassProcessName (checked for by name in formula), BypassTriggerTriggerName (apex framework will dynamically detect the TriggerName being bypassed.)

> Permission Sets: 

> General: RestrictAutomationForMigration, RestrictAutomationForIntegration, RestrictAllAutomation

> Stream specific* RestrictUpstreamAutomation, RestrictDownstreamAutomation, 

*Note that those marked with an asterix denotes that these are to be set up by the relevant stream / package as needed.

Examples: 
> Formula (boolean): *!$Permission.BypassProcessBuilder* (the ! mark denotes a NOT condition)
> Trigger blocking: Boolean canRunTrigger = *(FeatureManagement.checkPermission(‘BlockTrigger’+TriggerName) == FALSE*)

We also tested the Apex execution time of this and found it was highly performant. So consider it good to go!

Original Notes:

Automation for validation rules, process builder and triggers can be managed from the c_Automation__mtd custom metadata type. Automation control is the process of managing any automation on the platform from a central location (a custom metadata object).

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


