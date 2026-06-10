# Minecraft Server Automation with Terraform and Ansible
* Liam Gold
* CS312

## Overview

For this project, I automated the deployment of a Minecraft server on AWS using Terraform and Ansible. The goal was to create the infrastructure with Terraform and then use Ansible to configure the server automatically instead of manually installing everything through SSH.

Terraform was used to create the EC2 instance and security group, while Ansible was used to install Java, download the Minecraft server, accept the EULA, and create a systemd service so the server starts automatically after a reboot.

## Files

The project is organized into two main directories:

* `terraform/` - Infrastructure configuration
* `ansible/` - Server configuration and deployment

Important files:

* `main.tf`
* `variables.tf`
* `outputs.tf`
* `inventory.ini`
* `minecraft.yml`

## Requirements

Before running the project, the following software should be installed:

* AWS CLI
* Terraform
* Ansible
* Nmap
* Git

You will also need:

* AWS credentials configured locally
* An EC2 key pair
* Permission to create EC2 instances and security groups

To verify AWS credentials:

```bash
aws sts get-caller-identity
```

## Deploying the Infrastructure

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Review the deployment plan:

```bash
terraform plan
```

Create the AWS resources:

```bash
terraform apply
```

After the deployment completes, Terraform outputs the public IP address of the instance.

## Configuring the Server

Move to the Ansible directory:

```bash
cd ../ansible
```

Test connectivity:

```bash
ansible minecraft -i inventory.ini -m ping
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini minecraft.yml
```

The playbook performs the following tasks:

* Installs Java 21
* Creates a Minecraft user
* Creates the Minecraft directory
* Downloads the Minecraft server
* Accepts the EULA
* Creates a systemd service
* Enables the service on boot
* Starts the Minecraft server

## Verifying the Deployment

Check that the Minecraft service is running:

```bash
sudo systemctl status minecraft
```

The service should show as active and running.

To verify that the Minecraft server is reachable from outside the instance:

```bash
nmap -sV -Pn -p 25565 <public-ip>
```

Example result:

```text
25565/tcp open minecraft Minecraft 1.21.4
```

## Connecting to the Server

Open Minecraft and select Multiplayer.

Enter the public IP address of the EC2 instance:

```text
<public-ip>:25565
```

If the deployment completed successfully, the Minecraft client should connect to the server.

## Challenges

The biggest issue I encountered was configuring SSH access. Initially, I was unable to connect to the EC2 instance because the security group only allowed SSH connections from a different IP address. After updating the security group rules, I was able to connect using my key pair and continue with the Ansible configuration.

I also ran into issues with Terraform state files and provider files being committed to GitHub. This was resolved by updating the `.gitignore` file and removing the unnecessary files from the repository.

## What I Learned

This project helped me better understand Infrastructure as Code and configuration management. Before this project, I had created EC2 instances manually through the AWS console. Using Terraform and Ansible made it possible to automate the entire deployment process and reproduce the environment with minimal manual configuration.
