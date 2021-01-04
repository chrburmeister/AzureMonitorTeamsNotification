using namespace System.Net

param($Request, $TriggerMetadata)

$body = ConvertTo-Json -Depth 4 @{
    summary  = $Request.body.data.essentials.alertRule
    sections = @(
        @{
            activityTitle    = $Request.body.data.essentials.alertRule
            activitySubtitle = $Request.body.data.essentials.description
            activityText     = "Alert $($Request.body.data.essentials.alertRule) has fired"
        },
        @{
            title = 'Details'
            facts = @(
                @{
                    name  = 'Link To Search Results'
                    value = "[Link]($($Request.body.data.alertContext.LinkToFilteredSearchResultsUI))"
                },
                @{
                    name  = 'Search Start Time - UTC'
                    value = $Request.body.data.alertContext.SearchIntervalStartTimeUtc
                },
                @{
                    name  = 'Search End Time - UTC'
                    value = $Request.body.data.alertContext.SearchIntervalEndtimeUtc
                },
                @{
                    name  = 'Query Executed'
                    value = $Request.body.data.alertContext.SearchQuery
                },
                @{
                    name  = 'Log Analytics Workspace ID'
                    value = $Request.body.data.alertContext.WorkspaceId
                },
                @{
                    name  = 'Query Result Count'
                    value = $Request.body.data.alertContext.ResultCount
                },
                @{
                    name  = 'Threshold'
                    value = $Request.body.data.alertContext.Threshold
                }
            )
        }
    )
}

Invoke-RestMethod -uri $env:teams_webhook_url -Method Post -body $body -ContentType 'application/json'

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })