$connectTestResult = Test-NetConnection -ComputerName ramakrishna3006.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"ramakrishna3006.file.core.windows.net`" /user:`"localhost\ramakrishna3006`" /pass:`"ZGaw1fk+rsc7RK9hP9daYOYIEUZtLfxZyRMU+x7hVL5YViKDMG+F/uSe9QIP+jOBmIIrK7rL3XRa+AStNay/+g==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\ramakrishna3006.file.core.windows.net\docs-fs" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}