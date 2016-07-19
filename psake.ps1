$Config = Get-Content -Path '.\Config.json' | ConvertFrom-Json

task Plugins {
    $Plugins = Get-Content -Path '.\Plugins.json' | ConvertFrom-Json
    $Plugins | ForEach {
        $Uri = $_.Uri
        $BaseName = $_.BaseName
        $PluginPath = ".\Plugins\$BaseName"
        $Hashes = $_.Hash

        "Processing $BaseName"

        If (-Not (Test-Path -Path "$PluginPath")) {
            "  - Downloading"
            Invoke-WebRequest -Uri "$Uri" -OutFile "$PluginPath"
        }
        $_.Hash.Algorithms | ForEach {
            $ExpectedHash = $Hashes.$_
            $FileHash = Get-FileHash -Algorithm $_ -Path $PluginPath | Select-Object -ExpandProperty Hash

            If ($ExpectedHash -and $FileHash -ne $ExpectedHash) {
                "  - Expected hash: $ExpectedHash"
                "  - File hash    : $FileHash"
                throw "File hash of $Basename does not match"
            }

            If (-Not $ExpectedHash) {
                "  - File hash: $FileHash"
                Write-Warning "Plugin has no expected file hash"

            } else {
                "  - File hash OK"
            }
        }
    }
}

task ServerJar {
    Get-ChildItem -Path "$($Config.ServerJarSourcePath)" -Filter 'spigot-*.jar' | Copy-Item -Destination '.'
}

task Worlds -precondition {-Not (Test-Path -Path '.\Worlds')} {
    Copy-Item -Path "$($Config.WorldsSourcePath)" -Destination '.\Worlds' -Recurse
}

task RconPassword -precondition {-Not (Test-Path -Path '.\RCON.txt')} {
    Read-Host -Prompt 'Please enter password for RCON access' | Set-Content -Path '.\RCON.txt'
}

task Config -depends RconPassword -precondition {-Not (Test-Path -Path '.\server.properties')} {
    $rconPassword = Get-Content -Path '.\RCON.txt'
    Copy-Item -Path '.\server.properties.template' -Destination '.\server.properties' -Force
    "rcon.password=$rconPassword" | Add-Content -Path '.\server.properties'
}

task Clean {
    Remove-Item -Path '.\server.properties','.\RCON.txt'
    Remove-Item -Path '.\Worlds','.\Logs','.\Backup' -Recurse
    Remove-Item -Path '.' -Filter "*.jar" -Recurse
}

task default -depends Plugins,Worlds,Config