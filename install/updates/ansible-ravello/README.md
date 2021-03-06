OCP ansible ravello DNS update scripts
---
Updated for OCP 3.5

* Based off Ravello blueprint

## Setup
* Get private key: `sftp root@[workstation_ip]:.ssh/id_rsa ocp-ravello.pem`
  * Alternatively, you can add your public key to each VM
* You can put your credentials in the `creds.yml` or use environment variables for credentials.
  * `GOOGLE_DDNS_USER`
  * `GOOGLE_DDNS_PASSWORD`
  * `RAVELLO_USER`
  * `RAVELLO_PASSWORD`

### Scripted Method - Initial Run
* Prerequisite: ravello-sdk
  * `sudo pip install ravello-sdk`
* Modify `vars.yml` accordingly with configuration
* `ravello.sh`

### Scripted DDNS updates
* `ravello.sh update`

### Manual Method - Initial Run
* Modify `hosts` & `vars.yml` accordingly with IPs and configuration
* `ansible-playbook --private-key=ocp-ravello.pem -i hosts ocp_ddns.yml`

### Manual Subsequent DDNS updates
* Modify `hosts` with IPs
* `ansible-playbook --private-key=ocp-ravello.pem -i hosts ocp_ddns.yml --tags "update_dns"`
  * This will just run the tasks to update the dns server with the new ips.
  
## Connecting CloudForms 4.1 to the OCP environment
* From the workstation machine
  * `./oclogin.sh` - login as `admin`
  * `oc sa get-token -n management-infra management-admin` - to extract the token
* On CloudForms 4.1, Compute > Containers > Providers > Configuration > Add a new Containers Providers
  * Default endpoint: Use the token from the previous command
  * Hawkular endpoint: `metrics.<ocp_wildcard>.<subdomain>.<domain>`
  * Validate each endpoint to ensure connectivity
* Configure the CloudForms Management Engine to allow for all three Capacity & Utilization server roles, which are available under Configure → Configuration → Server → Server Control.[1]  

[1] [CloudForms documentation](https://access.redhat.com/documentation/en/red-hat-cloudforms/4.1/managing-providers/chapter-4-containers-providers)
  