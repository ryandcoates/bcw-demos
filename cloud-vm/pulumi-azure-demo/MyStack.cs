using Pulumi;
using Pulumi.Azure.Core;
using Azure = Pulumi.Azure;

class MyStack : Stack
{
    public MyStack()
    {
        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("bcw-demo-vm");

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
            AddressPrefixes = "10.0.2.0/24",
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
            //Size = "Standard_B1ms",
            Size = "Standard_D2s_v3",
            AdminUsername = "install",
            AdminPassword = "P@$$w0rd1234!",
            NetworkInterfaceIds =
            {
                networkInterface.Id,
            },
            //Plan = new Azure.Compute.Inputs.WindowsVirtualMachinePlanArgs
            //{
            //    Name = "pro-preview",
            //    Product = "windows10preview",
            //    Publisher = "microsoft-hyperv"
            //},
            OsDisk = new Azure.Compute.Inputs.WindowsVirtualMachineOsDiskArgs
            {
                Caching = "ReadWrite",
                StorageAccountType = "StandardSSD_LRS",
            },
            SourceImageReference = new Azure.Compute.Inputs.WindowsVirtualMachineSourceImageReferenceArgs
            {
                Publisher = "MicrosoftWindowsDesktop",
                Offer = "Windows11Preview",
                Sku = "win11-22h2-ent",
                Version = "latest",
            },
        });

        this.PublicIpAddress = publicIpAddress.IpAddress;
    }

    [Output("publicIpAddress")]
    public Output<string> PublicIpAddress { get; set; }

}
