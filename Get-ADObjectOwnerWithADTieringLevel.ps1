Import-Module ActiveDirectory

$Processed = @()
$ADComputers = Get-ADComputer -Filter * #-ResultSetSize 5
foreach($Computer in $ADComputers){

    $ACL = Get-Acl "AD:$($Computer.DistinguishedName)"
    
    #Get the Object Tiering level
    If($Computer.DistinguishedName.Contains("Tier0") -or $Computer.DistinguishedName.Contains("Domain Controllers")){
        $ADTier = "Tier-0"
    }
    If($Computer.DistinguishedName.Contains("Tier1")){
        $ADTier = "Tier-1"
    }
    If($Computer.DistinguishedName.Contains("Tier2")){
        $ADTier = "Tier-2"
    }

    #Get the Owner Tiering level
    $OwnerDetails = Get-ADObject -Filter "cn -eq ""$($ACL.Owner.split("\")[1])"""
    If($OwnerDetails.DistinguishedName.Contains("Tier0") -or $OwnerDetails.DistinguishedName.Contains("Domain Controllers") -or $OwnerDetails.DistinguishedName.Contains("Users")){
        $OwnerADTier = "Tier-0"
    }
    If($OwnerDetails.DistinguishedName.Contains("Tier1")){
        $OwnerADTier = "Tier-1"
    }
    If($OwnerDetails.DistinguishedName.Contains("Tier2")){
        $OwnerADTier = "Tier-2"
    }
    $Properties = [ORDERED]@{
        Name = $Computer.Name
        Owner = $ACL.Owner
        ObjectTierLevel = $ADTier
        OwnerTierLevel = $OwnerADTier
        DN = $Computer.DistinguishedName

    }

    $PObject = New-Object -TypeName PSObject -Property $Properties
    $Processed += $PObject
}
$Processed | Out-GridView -Title "AD Object Owners and AD Tiering"
