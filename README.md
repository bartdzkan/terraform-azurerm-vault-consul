This repo is forked from:
https://github.com/hashicorp/terraform-azurerm-vault

https://github.com/hashicorp/terraform-azurerm-consul

Originally made by [Gruntwork](http://www.gruntwork.io/).

I have merged the two projects, and updated the code.
Since the two repo's has not been updated or maintained for over a year.


# Vault and Consul Azure Module

This repo contains a Module to deploy a [Vault](https://www.vaultproject.io/) cluster on
[Azure](https://azure.microsoft.com/) using [Terraform](https://www.terraform.io/). Vault is an open source tool for
managing secrets. This Module uses [Azure Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-dotnet-how-to-use-blobs) as a [storage
backend](https://www.vaultproject.io/docs/configuration/storage/index.html) and a [Consul](https://www.consul.io)
server cluster as a [high availability backend](https://www.vaultproject.io/docs/concepts/ha.html)

Consul is a distributed, highly-available tool that you can use for service discovery and key/value storage. A Consul cluster typically includes a small number of server nodes, which are responsible for being part of the [consensus  quorum](https://www.consul.io/docs/internals/consensus.html), and a larger number of client nodes, which you typically
run alongside your apps::

![Vault architecture](https://raw.githubusercontent.com/bartdzkan/terraform-azurerm-vault-consul/master/_docs/architecture.png)

This Module includes:
##Vault Cluster

* [install-vault](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/install-vault): This module can be used to install Vault. It can be used in a
  [Packer](https://www.packer.io/) template to create a Vault
  [Azure Manager Image](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer).

* [run-vault](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/run-vault): This module can be used to configure and run Vault. It can be used in a
  [Custom Data](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/classic/inject-custom-data)
  script to fire up Vault while the server is booting.

* [vault-cluster](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/vault-cluster): Terraform code to deploy a cluster of Vault servers using an [Scale Set]
(https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-create).

* [private-tls-cert](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/private-tls-cert): Generate a private TLS certificate for use with a private Vault
  cluster.

* [update-certificate-store](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/update-certificate-store): Add a trusted, CA public key to an OS's certificate store. This allows you to establish TLS connections to services that use this TLS certs signed by this CA without getting x509 certificate errors.



##Consul Cluster
* [install-consul](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/install-consul): This module can be used to install Vault. It can be used in a
  [Packer](https://www.packer.io/) template to create a Vault
  [Azure Manager Image](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer).

* [run-consul](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/run-consul): This module can be used to configure and run Consul. It can be used in a
    [Custom Data](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/classic/inject-custom-data)
    script to fire up Vault while the server is booting.

* [consul-cluster](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/consul-cluster): Terraform code to deploy a cluster of Vault servers using an [Scale Set](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-create).

* [consul-security-group-rules](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/consul-security-group-rules): Defines the security group rules used by a Consul cluster to control the traffic that is allowed to go in and out of the cluster.

* [install-dnsmasq](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules/install-dnsmasq): This folder contains a script for installing Dnsmasq and configuring it to forward requests for a specific domain to Consul.

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such
as a database or server cluster. Each Module is created primarily using [Terraform](https://www.terraform.io/),
includes automated tests, examples, and documentation, and is maintained both by the open source community and
companies that provide commercial support.

Instead of having to figure out the details of how to run a piece of infrastructure from scratch, you can reuse
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself,
you can leverage the work of the Module community and maintainers, and pick up infrastructure improvements through
a version number bump.


## How do you use this Module?

Each Module has the following folder structure:

* [root](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/): The root folder contains the main terraform project and variables that other modules will use.
* [modules](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/modules): This folder contains the reusable code for this Module, broken down into one or more modules.
* [examples](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/examples): This folder contains the packer image example. Plus initial azure setup (Resource Group, Storage Account, and Secret key)

## How to Deploy
To remove Public IP loadbalancer go into module/vault-cluster and module/consul-cluster and comment out LoadBalancing Section and uncomment Non-Loadbalancing section.
You will need to use a bastion host/Jump Box to access Vault and Consul. Recommended for Production environments.

1. Create Azure Resource Group and Storage account - This is created separatly since the Packer Image needs to be created and uploaded before running the main terraform.
  * Go to examples/azure-project-setup
  * In vars.tf enter your Azure subscription_id, tenant_id, client_id, secret_access_key - Save the file
  * Now run terraform plan, terraform apply
  * Copy the output and enter it into the main vars.tf file under root. Also enter Azure subscription_id, tenant_id, client_id, secret_access_key, plus your ssh-rsa.
  * To find your ssh-rsa, in your terminal "cat ~/.ssh/id_rsa.pub" - Copy the whole output, create a new public rsa key if you like.

2. Create your SSL Certs
  * Go to /modules/private-tls-cert
  * Run terraform plan, terrform apply.
  * Copy certificates - ca.crt.pem, vault.crt.pem, vault.key.pem to examples/vault-consul-image/tls

3. Create Packer Image
  * Go to examples/vault-consul-image/vault-consul.json
  * Add Azure subscription_id, tenant_id, client_id, secret_access_key(client_secret) also add your github oath token.
  * If you want to use your own forked or cloned repo. Go to line 64 and edit the repo.
  * Save file.
  * Run "packer build vault-consul.json"
  * This will take some time to create your images and push to Azure.
  * Once it has completed copy the image_uri
  * Paste into main vars.tf in root, under image_uri ex. "/subscriptions/xxxxxxxx/resourceGroups/vault-consul-cluster/providers/Microsoft.Compute/images/vault-consul-ubuntu-2019-02-12-185900"

4. Deploy Vault and Consul Cluster
  * Go to the root directory
  * Run - terraform plan, terrform apply
  * This will take some time to complete.
  * Once successfully deploy it should output your external IP addresses.
  Ex "Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

      Outputs:

      consul_admin_user_name = consuladmin

      consul_cluster_size = 3
      consul_load_balancer_ip_address = [
        104.22.245.235
      ]
      vault_admin_user_name = vaultadmin
      vault_cluster_size = 3
      vault_load_balancer_ip_address = [
        104.22.222.210
      ]"

  5. Test to see if Consul is running.
  * Consul external IP Address with port 8500
  ex. http://104.22.245.235:8500
  * You will see errors since you need to initialize and unseal vault.

  6. Vault init and unseal.
  * Find the ssh port for vault. Go to Azure Console or use azure CLI.
  * Azure Console - resourceGroups/vault-consul-cluster/providers/Microsoft.Network/loadBalancers/vault-cluster_access/overview
  * You need to SSH into all three, but only 'vault init' on the first one.
  * ssh vaultadmin@104.22.222.210 -p 2200
  * Once logged in - Run 'vault operator init'
  * Vault will display your Unseal keys and Initial Root Token.
  ###Copy these to a safe place
  * To unseal your vault server - Run - 'vault unseal'
  * Copy one of your unseal keys. You will need to run this command another two times with the different keys. To unseal vault.
  * Login to the other two vault servers. No need to run 'vault operator init' since it is alrady intialized. Only Run - 'vault unseal'. You will need to do this 3 times as well, on each server.

  6. Complete
  * If you go back to your Consul API, you will see everything is healthy.

  7. Destroy
  * In the root directory - Run 'terraform destroy'
  * You might need to run this twice since sometimes Azure is slow.
  * Go to examples/azure-resource-project - Run 'terraform destroy' - or just run this to destroy everything.


### Tips and Tricks  






## License

This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/LICENSE) and [NOTICE](https://github.com/bartdzkan/terraform-azurerm-vault-consul/tree/master/NOTICE) for more
details.
