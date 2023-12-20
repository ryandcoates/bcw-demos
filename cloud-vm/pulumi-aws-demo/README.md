# BCW Cloud VM Demo w/ Infrastructure as Code

## Before Talk

1. Open in DevContainer
1. Login to Pulumi
1. Generate new Access key on IAM user in AWS Console
1. Add AWS Credentials to ~/.aws/credentials
1. Execute `make inf-up` to validate infrastructure build and access permissions
1. Execute `make inf-down` to clean up and prep for talk
1. Ensure Build and Push steps work (may need to disable host Tailscale)

## TODO

1. Fix base image to gather AWS creds from doppler?
1. Fix base image to include dotnet 8 and dotnet 6
