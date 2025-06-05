# MIT License
# 
# Copyright (c) 2025 Geoffrey Gontard
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.




if (!
    #current role
    (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    #is admin?
    )).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
) {
    #elevate script and exit current non-elevated runtime
    Start-Process `
        -FilePath 'powershell' `
        -ArgumentList (
            #flatten to single array
            '-File', $MyInvocation.MyCommand.Source, $args `
            | %{ $_ }
        ) `
        -Verb RunAs
    exit
}



# Install Winget
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Microsoft.WinGet.Client
Find-Module Microsoft.WinGet.Client
Import-Module Microsoft.WinGet.Client -Force



# Update softwares
winget source reset --force
winget upgrade --all --silent --include-unknown --accept-source-agreements --accept-package-agreements --source winget



# Update system
Find-Module PSWindowsUpdate | Install-Module
Import-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll



echo ""
echo ""
echo "Just a timeout in order to let you see the displayed command."
timeout /NoBreak 60