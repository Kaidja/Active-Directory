Param(
    [Parameter(Mandatory=$True,HelpMessage = "Please speficy keyword for GPO search")]
        $KeyWord
)

$GPOs = Get-GPO -All
foreach($GPO in $GPOs){
    Write-Output -InputObject "**** Processing $($GPO.DisplayName) GPO"
    $GPOData = Get-GPOReport -Name $GPO.DisplayName -ReportType Xml
    If($GPOData.Contains($KeyWord)){
        Write-Output -InputObject "-------- We found something in $($GPO.DisplayName) Group Policy"
    }
    Else{
        #Write-Output -InputObject "--- We didnt find anything. Please try again with a different Keyword"
    }
    
}
