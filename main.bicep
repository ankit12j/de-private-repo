param publicIPAddresses_dbx_vpn_pip_name string
param virtualNetworks_dbx_vpn_poc_vnet_name string
param publicIPAddresses_dbx_vpn_poc_publicip_name string
param publicIPAddresses_dbx_vpn_poc_vnet_gateway_pip_name string
param virtualNetworkGateways_dbx_vpn_poc_vnet_gateway_name string

resource publicIPAddresses_dbx_vpn_pip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_dbx_vpn_pip_name
  location: 'southindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.219.99.177'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_dbx_vpn_poc_publicip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_dbx_vpn_poc_publicip_name
  location: 'southindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.41.244.218'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_dbx_vpn_poc_vnet_gateway_pip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_dbx_vpn_poc_vnet_gateway_pip_name
  location: 'southindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '52.172.89.210'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_dbx_vpn_poc_vnet_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_dbx_vpn_poc_vnet_name
  location: 'southindia'
  tags: {
    dbx_vpn_poc: 'dbx_vpn_poc'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_dbx_vpn_poc_vnet_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_dbx_vpn_poc_vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_dbx_vpn_poc_vnet_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.0.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_dbx_vpn_poc_vnet_name_resource
  ]
}

resource virtualNetworkGateways_dbx_vpn_poc_vnet_gateway_name_resource 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
  name: virtualNetworkGateways_dbx_vpn_poc_vnet_gateway_name
  location: 'southindia'
  tags: {
    dbx_vpn_poc_vnet_gateway: 'dbx_vpn_poc_vnet_gateway'
  }
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_dbx_vpn_poc_vnet_gateway_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_dbx_vpn_poc_vnet_gateway_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_dbx_vpn_poc_vnet_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1AZ'
      tier: 'VpnGw1AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientAddressPool: {
        addressPrefixes: [
          '172.16.201.0/24'
        ]
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
      aadTenant: 'https://login.microsoftonline.com/ee83ff1b-0cde-42f6-9edd-2e1a431ca3c4/'
      aadAudience: 'c632b3df-fb67-4d84-bdcf-b95ad541b5c8'
      aadIssuer: 'https://sts.windows.net/e8e520cd-2201-4a2d-93fa-73eaf2da2cb5/'
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.0.1.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_dbx_vpn_poc_vnet_gateway_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    customRoutes: {
      addressPrefixes: []
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}
