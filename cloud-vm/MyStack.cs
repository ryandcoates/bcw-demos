using Pulumi;
using Pulumi.Azure.Core;
using Azure = Pulumi.Azure;

class MyStack : Stack
{
    public MyStack()
    {
        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("bcw-july20-vm");

        // Create a Virtual network
        var virtualNetwork = new Azure.Network.VirtualNetwork("bcw-vnet", new Azure.Network.VirtualNetworkArgs
        {
            AddressSpaces = 
            {
                "10.0.0.0/16",
            },
            Location = resourceGroup.Location,
            ResourceGroupName = resourceGroup.Name,
        });
        var subnet = new Azure.Network.Subnet("subnet", new Azure.Network.SubnetArgs
        {
            ResourceGroupName = resourceGroup.Name,
            VirtualNetworkName = virtualNetwork.Name,
            AddressPrefix = "10.0.2.0/24",
        });
        var publicIpAddress = new Azure.Network.PublicIp("publicIp", new Azure.Network.PublicIpArgs
        {
            ResourceGroupName = resourceGroup.Name,
            Location = resourceGroup.Location,
            AllocationMethod = "Dynamic",
        });
        var networkInterface = new Azure.Network.NetworkInterface("networkInterface", new Azure.Network.NetworkInterfaceArgs
        {
            Location = resourceGroup.Location,
            ResourceGroupName = resourceGroup.Name,
            IpConfigurations = 
            {
                new Azure.Network.Inputs.NetworkInterfaceIpConfigurationArgs
                {
                    Name = "internal",
                    SubnetId = subnet.Id,
                    PrivateIpAddressAllocation = "Dynamic",
                    PublicIpAddressId = publicIpAddress.Id
                },
            },
        });

        var windowsVirtualMachine = new Azure.Compute.WindowsVirtualMachine("demoVm", new Azure.Compute.WindowsVirtualMachineArgs
        {
            ResourceGroupName = resourceGroup.Name,
            Location = resourceGroup.Location,
            Size = "Standard_B1ms",
            AdminUsername = "install",
            AdminPassword = "P@$$w0rd1234!",
            NetworkInterfaceIds = 
            {
                networkInterface.Id,
            },
            Plan = new Azure.Compute.Inputs.WindowsVirtualMachinePlanArgs
            {
                Name = "pro-preview",
                Product = "windows10preview",
                Publisher = "microsoft-hyperv"
            },
            OsDisk = new Azure.Compute.Inputs.WindowsVirtualMachineOsDiskArgs
            {
                Caching = "ReadWrite",
                StorageAccountType = "StandardSSD_LRS",
            },
            SourceImageReference = new Azure.Compute.Inputs.WindowsVirtualMachineSourceImageReferenceArgs
            {
                Publisher = "microsoft-hyperv",
                Offer = "windows10preview",
                Sku = "pro-preview",
                Version = "19041.208.2004162051",
            },
        });

        this.PublicIpAddress = publicIpAddress.IpAddress;
    }

    [Output] public Output<string> PublicIpAddress { get; set; }

}
