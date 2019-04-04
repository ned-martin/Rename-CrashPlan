<#
.Synopsis
	Rename files so CrashPlan can back them up

.Description
	Rename files so CrashPlan can back them up
	https://support.code42.com/CrashPlan/6/Troubleshooting/What_is_not_backing_up

.Parameter WhatIf
	Shows what would happen if the cmdlet runs. The cmdlet is not run.
#>

function Rename-CrashPlan {
	param(
		[Switch] $WhatIf
	)

	$Rename = ".bck",
	".bkf",
	".hdd",
	".hds",
	".nvram",
	".ost",
	".part",
	".pvm",
	".pvs",
	".rbf",
	".sparseimage",
	".tib",
	".tmp",
	".vdi",
	".vfd",
	".vhd",
	".vhdx",
	".vmc",
	".vmdk",
	".vmem",
	".vmsd",
	".vmsn",
	".vmss",
	".vmtm",
	".vmwarevm",
	".vmx",
	".vmxf",
	".vsv",
	".vud",
	".xva"

	$LogFile = "Rename-CrashPlan.log";
	$Pattern = (($Rename | % { "\" + $_ + "$|\.rename-" + ($_).subString(1) + "$" }) -join "|")

	if(!$WhatIf) {
		echo ($log = ("`r`nStart Rename " + (Get-Date)))
		Add-Content $LogFile $log
	}

	Get-ChildItem -Force -Recurse | Where{$_.Name -match $Pattern } | % {

		if($Matches[0] -match "\.rename-.*") {
			$NewName = ($_.Name -Replace "\.rename-.+$", ($Matches[0].replace(".rename-", ".")))
		}
		else {
			$NewName = ($_.Name -Replace ("\" + $Matches[0] + "$"), (".rename-" + $Matches[0].subString(1)))
		}

		if($WhatIf) {
			Rename-Item $_.FullName -NewName $NewName -WhatIf
		} else {
			Rename-Item $_.FullName -NewName $NewName
		}

		if(!$WhatIf) {
			echo ($log = ($_.FullName + " > " + $NewName))
			Add-Content $LogFile $log
		}
	}
}

Export-ModuleMember -Function 'Rename-CrashPlan'