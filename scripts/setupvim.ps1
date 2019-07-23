[CmdLetBinding()]
Param()

$PrevEAP = $ErrorActionPreference
$ErrorActionPreference="SilentlyContinue"
$script:IsWindows = (-not (Get-Variable -Name IsWindows -ErrorAction Ignore)) -or $IsWindows
$ErrorActionPreference=$PrevEAP

function Get-RegisteredFonts {
    $FontRegPaths = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts',
		'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
	foreach ($FontRegPath in $FontRegPaths) {
		$FontRegKey = Get-Item $FontRegPath
		$FontRegKey.GetValueNames() | ForEach-Object {
			[PSCustomObject]@{
				'Font' = $_
				'File' = $FontRegKey.GetValue($_).Split('\')[-1]
			}
		}
	}
}

function InvokeVerb {
    param([string]$FilePath,$Verb)
    $Verb = $Verb.Replace("&","")
    $Path = split-path $FilePath
    $Shell = New-Object -Com "Shell.Application"
    $Folder = $Shell.Namespace($Path)
    $Item = $Folder.Parsename((Split-Path $FilePath -Leaf))
    $ItemVerb = $Item.Verbs() | Where-Object {
        $_.Name.Replace("&","") -eq $Verb
    }
    if($Null -eq $ItemVerb){
        throw "Verb $Verb not found."
    } else {
        $ItemVerb.DoIt()
        Write-Verbose "Succesfully invoked verb $Verb on $FilePath"
    }
}

function Get-FiraCodeDownload {
(invoke-webrequest -uri "https://api.github.com/repos/tonsky/FiraCode/releases/latest"|ConvertFrom-Json).assets.browser_download_url
}

function Install-FiraCode {
	#Download to temp
	$DownloadURL = Get-FiraCodeDownload
    $FileName = $DownloadURL.split('/')[-1]
	$TempDir = New-Item -ItemType Directory -Path $Env:Temp -Name (Get-Random)
    $WebRequest = @{
        Uri = $DownloadURL
        OutFile = (Join-Path -Path $TempDir -Child $FileName)
		UseBasicParsing = [Switch]$True
	}
    Invoke-WebRequest @WebRequest
	Expand-Archive $WebRequest.OutFile -Destination $TempDir
	$Fonts = Get-ChildItem $TempDir -Recurse -Filter *.ttf
	$InstalledFonts = Get-RegisteredFonts
	ForEach ($Font in $Fonts) {
		# Install each font
		If ($Font.Name -notin $InstalledFonts.File) {
			InvokeVerb -FilePath $Font.FullName -verb "Install"
		} else {
			Write-Verbose "$($Font.Name) already installed"
		}
	}
	Remove-Item $TempDir -Force -Recurse
}

if ($IsWindows) {
    $PrevEAP = $ErrorActionPreference
    $ErrorActionPreference="SilentlyContinue"
    # On Windows, we need to be elevated to create links
    if (-Not((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) { 
        #Start-Process -FilePath "$((get-process -Id $PID).ProcessName).exe" -Verb runAs -ArgumentList "-NoExit -File $PSCommandPath"
        Write-Warning "We weren't elevated, which we need on Windows"
        #return
    }
    $VIMFILES = "$HOME\vimfiles"
    $VIMRC = "$HOME\_vimrc"
    If (Get-Command choco) {
        # Only install vimplug if we aren't using OneDrive    
        $VPlugP = "$Env:userprofile\vimfiles\autoload\plug.vim"
        if (!(get-command git)) { choco install git -y }
        if (!(get-command vim)) { choco install vim -y }
    }
    If (-Not(Get-Module -ListAvailable PSScriptAnalyzer)) {
        Get-PackageProvider nuget -Force
        Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
    }
	Install-FiraCode
    $ErrorActionPreference=$PrevEAP

} else {
    $VIMFILES = "$HOME/.vim"
    $VIMRC = "$HOME/.vimrc"
}

function Install-VPlug {
    $VPlugURL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    $VPlugP = "$VIMFILES/autoload/plug.vim"
    if (!(Test-Path -Path $VPlugP)) {
        New-Item -ItemType Directory (Split-Path -Path $VPlugP -Parent) -Force
        Invoke-WebRequest -Uri $VPlugURL -OutFile $VPlugP
    }
}


function New-SymbolicLink {
    [CmdLetBinding()]
	Param($Target,$Link, [switch]$s)

	If (Test-Path -Path $Link) {
		Write-Information "File/Link already exists : $Link"
	} else {
		If ($PSVersionTable.Platform -eq 'Unix') {
			ln -s $Target $Link
		} else {
			If ((Get-Item $Target).PSIsContainer) {
                Write-Verbose "Creating Directory link: $Link at $Target"
				cmd.exe /c mklink /D "$Link" "$Target"
			} else {
                Write-Verbose "Creating File link: $Link at $Target"
				cmd.exe /c mklink "$Link" "$Target"
			}
		}
	}
}

Push-Location
Set-Location (Split-Path -Path $PSScriptRoot -Parent)

if (-Not (Test-Path "${VIMFILES}")) {
    New-Item -ItemType Directory -Path $VIMFILES
}
if (-Not (Test-Path "${VIMFILES}/autoload/plug.vim")) {
    Install-VPlug
}
if (Test-Path vimfiles) {
    Copy-Item -Recurse vimfiles/* "$VIMFILES" -Force
}

if ((Test-Path _vimrc) -and (-Not (Test-Path "${VIMRC}"))) {
    New-SymbolicLink (Get-Item _vimrc).FullName "$VIMRC"
} else {"No"}

Pop-Location