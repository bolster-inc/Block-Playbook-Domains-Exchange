<#
.SYNOPSIS
    Block domains returned by Bolster Playbook in Microsoft Exchange

.DESCRIPTION
    - PREREQUISITE step to run this program - Connect to Exchange Online: https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps
    - Given a Playbook ID, this script downloads the latest playbook, extracts the domains and blocks them in Microsoft Exchange.
    - Once blocked, any incoming email with the blocked domain will get quarantined.

.EXAMPLE
    BlockPlaybookUrls.ps1 <API_KEY>  <Playbook ID>
#>

$api_key = $args[0]
$url_get_playbook_id = "https://developers.bolster.ai/api/neo/v1/playbook"
$playbook_id = $args[1]
$params = @{ apiKey = $api_key }

# Make API request, get history id of the latest playbook run
$parsed_json = Invoke-WebRequest $url_get_playbook_id -Method Post -Body $params -UseBasicParsing | ConvertFrom-Json
$first_object = $parsed_json.schedules | Where-Object {$_.id -eq $playbook_id}
$history_id = $first_object.history[0].id
$history_id_int = [Int32]$history_id
$result_count = $first_object.history[0].resultCount

if ($result_count -gt 0) {
    $url_get_playbook_content = "https://developers.bolster.ai/api/neo/v1/playbook/download"
    $params_content = @{ apiKey = $api_key; historyId = $history_id_int }
    
    #Make second API request to download Playbook content and block domains in Exchange
    $parsed_content_json = Invoke-WebRequest $url_get_playbook_content -Method Post -Body $params_content -UseBasicParsing | ConvertFrom-Json 
    Write-Output $parsed_content_json | ForEach-Object { New-TenantAllowBlockListItems -ListType Url -Block -Entries $_."Domain Name" }
}