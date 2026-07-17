param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPassword string
param vmSize string = 'Standard_B2ms'

var vnetName = 'lb-vnet'
var subnetName = 'web-subnet'
var nsgName = 'web-nsg'
var lbName = 'web-loadbalancer'
var lbFrontendName = 'LoadBalancerFrontEnd'
var lbBackendPoolName = 'LoadBalancerBackEndPool'
var lbProbeName = 'http-health-probe'
var lbRuleName = 'http-loadbalancing-rule'
var vm1Name = 'vm01'
var vm2Name = 'vm02'
var nic1Name = 'vm01-nic'
var nic2Name = 'vm02-nic'
var ipConfigName = 'ipconfig'
var vmOsPublisher = 'MicrosoftWindowsServer'
var vmOsOffer = 'WindowsServer'
var vmOsSku = '2022-Datacenter'

var vm1Html = '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Azure Load Balancer — End-to-End Reference</title>
<style>
  :root{
    --bg: #090d17;
    --bg-alt: #0d1322;
    --panel: #111a2e;
    --panel-2: #0d1526;
    --border: #1e293f;
    --border-soft: #17203380;
    --text: #e7ecf5;
    --text-dim: #8a93a8;
    --text-faint: #5c6580;
    --cyan: #22d3ee;
    --cyan-dim: #22d3ee33;
    --green: #34d399;
    --green-dim: #34d39933;
    --amber: #fbbf24;
    --amber-dim: #fbbf2433;
    --violet: #a78bfa;
    --violet-dim: #a78bfa33;
    --red: #f87171;
    --mono: ui-monospace, "SF Mono", "Cascadia Code", Consolas, monospace;
    --sans: -apple-system, "Segoe UI", system-ui, Roboto, sans-serif;
  }
  *{box-sizing:border-box; margin:0; padding:0;}
  html{scroll-behavior:smooth;}
  body{
    background: var(--bg);
    background-image:
      radial-gradient(ellipse 900px 500px at 15% -5%, #0f2a3540, transparent),
      radial-gradient(ellipse 700px 500px at 100% 10%, #1a123a40, transparent);
    color: var(--text);
    font-family: var(--sans);
    line-height: 1.6;
    -webkit-font-smoothing: antialiased;
    padding-bottom: 80px;
  }
  ::selection{ background: var(--cyan-dim); color: var(--text); }
  .hero{ padding: 64px 24px 40px; max-width: 1180px; margin: 0 auto; display:grid; grid-template-columns: 1.1fr 1fr; gap: 40px; align-items:center; }
  .hero h1{ font-size: 44px; font-weight: 700; letter-spacing:-1px; line-height:1.08; margin-bottom: 18px; }
  .hero p{ color: var(--text-dim); font-size: 15.5px; max-width: 520px; }
  .hero .label{ color: var(--cyan); font-family: var(--mono); letter-spacing: 1px; margin-bottom: 20px; display:block; }
</style>
</head>
<body>
  <div class="hero">
    <div>
      <span class="label">VM01</span>
      <h1>Azure Load Balancer Demo</h1>
      <p>This page is hosted on VM01 and served through the Azure Load Balancer backend pool.</p>
    </div>
  </div>
</body>
</html>'''

var vm2Html = '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Azure Load Balancer — End-to-End Reference</title>
<style>
  :root{
    --bg: #090d17;
    --bg-alt: #0d1322;
    --panel: #111a2e;
    --panel-2: #0d1526;
    --border: #1e293f;
    --border-soft: #17203380;
    --text: #e7ecf5;
    --text-dim: #8a93a8;
    --text-faint: #5c6580;
    --cyan: #22d3ee;
    --cyan-dim: #22d3ee33;
    --green: #34d399;
    --green-dim: #34d39933;
    --amber: #fbbf24;
    --amber-dim: #fbbf2433;
    --violet: #a78bfa;
    --violet-dim: #a78bfa33;
    --red: #f87171;
    --mono: ui-monospace, "SF Mono", "Cascadia Code", Consolas, monospace;
    --sans: -apple-system, "Segoe UI", system-ui, Roboto, sans-serif;
  }
  *{box-sizing:border-box; margin:0; padding:0;}
  html{scroll-behavior:smooth;}
  body{
    background: var(--bg);
    background-image:
      radial-gradient(ellipse 900px 500px at 15% -5%, #0f2a3540, transparent),
      radial-gradient(ellipse 700px 500px at 100% 10%, #1a123a40, transparent);
    color: var(--text);
    font-family: var(--sans);
    line-height: 1.6;
    -webkit-font-smoothing: antialiased;
    padding-bottom: 80px;
  }
  .hero{ padding: 64px 24px 40px; max-width: 1180px; margin: 0 auto; display:grid; grid-template-columns: 1.1fr 1fr; gap: 40px; align-items:center; }
  .hero h1{ font-size: 44px; font-weight: 700; letter-spacing:-1px; line-height:1.08; margin-bottom: 18px; }
  .hero p{ color: var(--text-dim); font-size: 15.5px; max-width: 520px; }
  .hero .label{ color: var(--cyan); font-family: var(--mono); letter-spacing: 1px; margin-bottom: 20px; display:block; }
</style>
</head>
<body>
  <div class="hero">
    <div>
      <span class="label">VM02</span>
      <h1>Azure Load Balancer Demo</h1>
      <p>This page is hosted on VM02 and served through the Azure Load Balancer backend pool.</p>
    </div>
  </div>
</body>
</html>'''

var vm1HtmlBase64 = base64(vm1Html)
var vm2HtmlBase64 = base64(vm2Html)

var lbFrontendConfigId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, lbFrontendName)
var lbBackendPoolId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, lbBackendPoolName)
var lbProbeId = resourceId('Microsoft.Network/loadBalancers/probes', lbName, lbProbeName)

var vm1InstallScript = concat(
  'powershell -ExecutionPolicy Unrestricted -Command "Install-WindowsFeature -Name Web-Server -IncludeManagementTools; $html = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("',
  vm1HtmlBase64,
  '")); Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value $html -Encoding UTF8"'
)

var vm2InstallScript = concat(
  'powershell -ExecutionPolicy Unrestricted -Command "Install-WindowsFeature -Name Web-Server -IncludeManagementTools; $html = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("',
  vm2HtmlBase64,
  '")); Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value $html -Encoding UTF8"'
)

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: '${lbName}-publicip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-05-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: lbFrontendName
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: lbBackendPoolName
      }
    ]
    probes: [
      {
        name: lbProbeName
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: lbRuleName
        properties: {
          frontendIPConfiguration: {
            id: lbFrontendConfigId
          }
          backendAddressPool: {
            id: lbBackendPoolId
          }
          probe: {
            id: lbProbeId
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          loadDistribution: 'Default'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Http'
        properties: {
          description: 'Allow HTTP traffic to the VMs.'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-RDP'
        properties: {
          description: 'Allow RDP for management.'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-Outbound'
        properties: {
          description: 'Allow all outbound traffic.'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

var subnetId = subnet.id

resource nic1 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nic1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: ipConfigName
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          loadBalancerBackendAddressPools: [
            {
              id: lbBackendPoolId
            }
          ]
        }
      }
    ]
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: ipConfigName
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          loadBalancerBackendAddressPools: [
            {
              id: lbBackendPoolId
            }
          ]
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vm1Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: vmOsPublisher
        offer: vmOsOffer
        sku: vmOsSku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    osProfile: {
      computerName: vm1Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic1.id
        }
      ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vm2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: vmOsPublisher
        offer: vmOsOffer
        sku: vmOsSku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    osProfile: {
      computerName: vm2Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic2.id
        }
      ]
    }
  }
}

resource vm1Extension 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  parent: vm1
  name: 'CustomScriptExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: vm1InstallScript
    }
  }
}

resource vm2Extension 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  parent: vm2
  name: 'CustomScriptExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: vm2InstallScript
    }
  }
}

output loadBalancerPublicIp string = publicIp.properties.ipAddress
output vm1PrivateIp string = nic1.properties.ipConfigurations[0].properties.privateIPAddress
output vm2PrivateIp string = nic2.properties.ipConfigurations[0].properties.privateIPAddress
