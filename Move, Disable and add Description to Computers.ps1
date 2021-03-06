# --------------------------------------------------------
# Note: if you see the following <# #> with text inbetween
# then it is a comment. If you see a hash symbol with text
# directly after it then it is a command that has been
# commented out!
# --------------------------------------------------------


<# Imports Module and CSV file #>

Import-module ActiveDirectory 
Import-CSV ".\ComputerList.csv" | % { 


<# Sets Variables based on AD Enviroment and Reason Code #>

$Computer = $_.ComputerName
$Date = Get-Date -Format dd/MM/yy
$User = $env:username
$Reason = Read-host "Enter a Reason"
$Desc = "Disabled on $Date by $User as $reason"
$ou = "OU=Disabled Computers,DC=ad,DC=hd,DC=hastdeer,DC=com,DC=au"


<# Uses Variables to put the Computer in the correct AD Group,
add a Description and then Disable that computer #>

Get-ADComputer $Computer | Move-ADObject -TargetPath $ou
Set-ADComputer $Computer -description $Desc
Set-ADComputer $Computer -Enabled $false
}

<# Renames CSV file to advise it has been processed on
X Date #>

Rename-Item .\ComputerList.csv "ComputerLists- Processed $Date.csv"