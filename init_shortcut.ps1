# Get the current directory
$currentDirectory = Get-Location

#Get the location of the source File of which the shortcut needs to be made
$SourceFileLocation = "$currentDirectory\bin\downloader.ps1"

# Location of the created shortcut-name
$ShortcutLocation = ".\youtube-downloader.lnk"

# start directory of the shortcut
$workingDirectory = "$currentDirectory\bin"

#get the powershell 
$powershell = "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe"

#shortcut-command-arguments
$shortcutArguments = "-ExecutionPolicy RemoteSigned -File `"$SourceFileLocation`""


#create a new script shell
$WScriptShell = New-Object -ComObject WScript.Shell

#Instantiating the shortcut object
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $powershell
$Shortcut.Arguments = $shortcutArguments
$Shortcut.IconLocation = "$currentDirectory\res\app.ico"
$Shortcut.WorkingDirectory = $workingDirectory


# Create the icon
$Shortcut.Save()