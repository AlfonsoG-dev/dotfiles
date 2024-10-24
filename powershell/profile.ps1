Import-Module posh-git
Import-Module -Name Terminal-Icons

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption –HistoryNoDuplicates:$True
