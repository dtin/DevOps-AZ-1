# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
- **Deploy a Policy**
Go to Azure Portal. Look up the Policy service and create a definition with the name "**tagging-policy**" and use the content provided in the file "**policy-tags-deny.json**" for the policy rules. 

After creating a definition successfully, you will need to assign a policy definition to the corresponding scope.

- **Packer Template**
Go to Azure Portal and open the Bash CLI. You will need to upload the file "**server.json**" using Bash CLI provided by Azure Portal.

You can verify the file has been uploaded successfully by using the command:
```bash
ls
```

Next, run the command to create an custom image using the Azure CLI:
```bash
packer build server.json
```

- **Terraform Template**
Open the **Command Prompt**, change the directory to the folder **terraform** and run the following command:

```bash
terraform apply "solution.plan"
```

#### (Optional)
You can also change the config using the following command, be aware that you need to run this before running the above command:
```bash
terraform plan -out solution.plan
```

### Output
- **Deploy a Policy**
Upload image evidence Policy assign successfully

- **Packer Template**
Upload image evidence Packer run successfully

- **Terraform Template**
Upload image evidence Terraform run successfully