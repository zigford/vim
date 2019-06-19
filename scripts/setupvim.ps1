[CmdLetBinding()]
Param()

$PrevEAP = $ErrorActionPreference
$ErrorActionPreference="SilentlyContinue"
$script:IsWindows = (-not (Get-Variable -Name IsWindows -ErrorAction Ignore)) -or $IsWindows
$ErrorActionPreference=$PrevEAP
if ($IsWindows) {
    # On Windows, we need to be elevated to create links
    if (-Not((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) { 
        Start-Process -FilePath "$((get-process -Id $PID).ProcessName).exe" -Verb runAs -ArgumentList "-NoExit -File $PSCommandPath"
        Write-Warning "We weren't elevated, which we need on Windows"
        return
    }
    $VIMFILES = "$HOME\vimfiles"
    $VIMRC = "$HOME\_vimrc"
    If (Get-Command choco) {
        # Only install vimplug if we aren't using OneDrive    
        $VPlugP = "$Env:userprofile\vimfiles\autoload\plug.vim"
	if (!(get-command git)) { choco install git -y }
	if (!(get-command vim)) { choco install vim -y }
	choco install firacode -y
    }
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

if (-Not (Test-Path "${VIMFILES}")) {
    New-Item -ItemType Directory -Path $VIMFILES
}
if (Test-Path vimfiles) {
    Copy-Item -Recurse vimfiles/* "$VIMFILES" -Force
}

if ((Test-Path _vimrc) -and (-Not (Test-Path "${VIMRC}"))) {
    New-SymbolicLink (Get-Item _vimrc).FullName "$VIMRC"
} else {"No"}

if (-Not (Test-Path "${HOME}/.vimtmp")) {
    New-Item -ItemType Directory -Path $HOME -Name .vimtmp
}
