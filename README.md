# deploy-juiceshop

## Query for WAF detections in Log Analytics

```AzureDiagnostics | where Category == "FrontdoorWebApplicationFirewallLog"
| order by TimeGenerated
```
