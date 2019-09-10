/**********************************************************************
 Name: Account.Trigger
 Other classes used: AccountTriggerHandler.cls
======================================================
Description:
    1. Trigger pattern using Kevin O'Hara's trigger framework
======================================================
History
-------
VERSION         AUTHOR              DATE            DETAIL
    1.0         Matt Evans       25/08/2019      Initial pattern
***********************************************************************/
trigger Account on Account (before insert, before update, before delete)
{
    new AccountTriggerHandler().run();
}