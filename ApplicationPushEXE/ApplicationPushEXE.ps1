#ApplicationPushEXE.ps1 by DesiredUsernameIsUnavailable
#Created 09.22.2017
#https://github.com/DesiredUsernameIsUnavailable/

$ErrorActionPreference = "silentlycontinue"
$curDir = $myinvocation.MyCommand.Definition | split-path -parent
$path = "$curDir"
$exportPath = "$path"
$computers = gc "$path\stationlist.txt"
$ping = new-object System.Net.NetworkInformation.Ping

#start
foreach($computer in $computers)
 {
$test = $ping.send($computer)

if (!$?) 
{ 
#Ping failed due to no DNS record.
"$computer-No DNS Record" | Out-File -Append $exportPath\failed.log
}
elseif ($test.status -eq "Success")
{
$process =([WMICLASS]"\\$computer\ROOT\CIMV2:win32_process")
$command1 = "cmd.exe /c c:\temp\ApplicationPushEXE\Application.exe /silent”

Copy-Item -Path $path\ApplicationPushEXE -Destination \\$computer\c$\temp\ -Force -Recurse | Out-Null

#Opens command prompt on local station and installs software.
$process.Create($command1) | Out-Null
}
Else 
{
#Ping failed, no response.
$computer | Out-File -Append $exportPath\failed.log
}
}

#Optional lines to open logfiles.
##invoke-item $exportpath\failed.log
##invoke-item $exportpath\logfile.log