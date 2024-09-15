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

Alternatively, you can change the value configured in file "**vars.tf**". The meaning of each variable will be explained as below:

**prefix**: The prefix which should be used for all resources. The default value will be **udacity**.

**location**: The Azure Region in which all resources should be created. The default value will be **southcentralus**. This value should be changed to the closest region that your end user mostly working in.

**admin_username**: The admin username for the VM being created. The default value will be **tindd3**. This should be an alternative way to access the VM in case your SSH Key is not working.

**admin_password**: The admin password for the VM being created. The default value will be **Password!123**. This should be an alternative way to access the VM in case your SSH Key is not working.

**number_of_virtual_machines**: The number of virtual machines should be created. The default value will be **3**.

### Output
- **Deploy a Policy**
![output-policy-assigned-2](https://github.com/user-attachments/assets/c60e2567-03b5-45b6-9dd4-8b6162bc0e5b)

- **Packer Template**
![output-packer-build-successfully-1](https://github.com/user-attachments/assets/d40a132e-03fe-4fd4-b760-c6aa7b5ae359)
![output-packer-build-successfully-2](https://github.com/user-attachments/assets/c096ca33-e11d-4292-bf0b-053558ab07a7)

- **Terraform Template**
![output-terraform-successfully-1](https://github.com/user-attachments/assets/9097bde7-0cd8-41d1-aa53-e669eb9b56df)
![output-terraform-successfully-2](https://github.com/user-attachments/assets/19adec69-800b-4682-b0be-6c9787ff84e4)
