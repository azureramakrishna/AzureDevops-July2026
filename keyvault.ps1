# Login
# Connect-AzAccount

# Variables
$resourceGroup = "rg-keyvault"
$location = "EastUS"
$keyVaultName = "ramakrishnakv-645"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Key Vault
New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroup -Location $location -EnableRbacAuthorization

# # Create Secret
# $secret = ConvertTo-SecureString "MyPassword@123" -AsPlainText -Force

# Set-AzKeyVaultSecret `
#     -VaultName $keyVaultName `
#     -Name "AdminPassword" `
#     -SecretValue $secret

# # Verify
# Get-AzKeyVaultSecret `
#     -VaultName $keyVaultName `
#     -Name "AdminPassword"


Get-AzKeyVaultSecret -VaultName "ramakrishnakv-645" | ForEach-Object { $s = Get-AzKeyVaultSecret -VaultName "ramakrishnakv-645" -Name $_.Name; [PSCustomObject]@{Name=$_.Name; Value=$s.SecretValueText} } | Format-Table -AutoSize