# Block-Playbook-Domains-Exchange
Powershell script to block domains returned by Bolster Playbook in Microsoft Exchange

PREREQUISITE
Connect to Exchange Online in Powershell: https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps

DESCRIPTION
- Given a Playbook ID, this script downloads the latest Bolster playbook, extracts the domains and blocks them in Microsoft Exchange.
- Once blocked, any incoming email with the blocked domain will get quarantined.

USAGE

PS > BlockPlaybookUrls.ps1 <API_KEY> <PLAYBOOK_ID>
