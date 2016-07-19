Set-Location -Path "$PSScriptRoot"
$LatestJar = Get-ChildItem spigot-*.jar | Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty Name
& Java.exe -Xmx1024M -Xms32M -jar "$LatestJar" -W "$PSScriptRoot\worlds"