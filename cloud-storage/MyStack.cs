using Pulumi;
using Pulumi.Azure.Core;
using Pulumi.Azure.Storage;
using Pulumi.Azure.Storage.Inputs;

class MyStack : Stack
{
    public MyStack()
    {
        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("bcw-july20-storage");

        // Create an Azure Storage Account
        var storageAccount = new Account("storage", new AccountArgs
        {
            ResourceGroupName = resourceGroup.Name,
            AccountReplicationType = "LRS",
            AccountTier = "Standard",
            StaticWebsite = new AccountStaticWebsiteArgs
            {
                IndexDocument = "index.html"
            },
            Tags =
            {
                { "Environment", "Demo" }
            }
        });

        var files = new[] { "index.html", "404.html" };
        foreach (var file in files)
        {
            var uploadedFile = new Blob(file, new BlobArgs
            {
                Name = file,
                StorageAccountName = storageAccount.Name,
                StorageContainerName = "$web",
                Type = "Block",
                Source = new FileAsset($"./wwwroot/{file}"),
                ContentType = "text/html",
            });
        }

        // Export the connection string and storage account URL for the storage account
        // this.ConnectionString = storageAccount.PrimaryConnectionString;
        this.StaticEndpoint = storageAccount.PrimaryWebEndpoint;
    }

    [Output] public Output<string> ConnectionString { get; set; }
    [Output] public Output<string> StaticEndpoint { get; set; }
}
