(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search('IsInstalled=0 and IsHidden=1').Updates | %{'KB'+$_.KBArticleIDs}
