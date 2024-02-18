# sunkenland-on-aws

[![build](https://github.com/wahlfeld/sunkenland-on-aws/actions/workflows/build.yml/badge.svg)](https://github.com/wahlfeld/sunkenland-on-aws/actions/workflows/build.yml)

## Why does this project exist?

This project exists because I wanted a cheaper and more efficient way to host a
Sunkenland server. Using AWS and Terraform this project will create a single
Sunkenland server which is ready to join from the Sunkenland server browser.

## Features

* Cheap
* Backups
* Monitoring
* Remote management

## Requirements

* MacOS required to run this code (or Linux, but will require some fiddling
  around)
* AWS account including CLI configured on your machine
* Terraform

## Usage

1. Create a Terraform backend S3 bucket to store your state files
2. Copy and paste the `template` folder somewhere on your computer
3. Configure `terraform.tf` to point at the S3 bucket you just created
4. Create a file called `terraform.tfvars` as per the input descriptions in
   `inputs.tf` E.g.
```
aws_region       = "ap-southeast-2"    // Choose a region closest to your physical location
sns_email        = "mrsmith@gmail.com" // Alert go here e.g. server started, server stopped
world_name       = "super cheap world"
server_password  = "nohax"
```
5. Run `terraform init && terraform apply`
6. TODO: Investigate way to provide world file

### Example folder structure

```
sunkenland-on-aws           // (this project)
└── your-sunkenland-server  // (create me)
    ├── inputs.tf        // (copied from ./template)
    ├── main.tf          // (copied from ./template)
    ├── outputs.tf       // (copied from ./template)
    ├── terraform.tf     // (copied from ./template)
    └── terraform.tfvars // (create me, example above)
```

### Monitoring

To view server monitoring metrics visit the `monitoring_url` output from
Terraform after deploying. Note that this URL will change every time the server
starts unless you're using your own domain in AWS. In this case I find it's
easier to just take note of the public IP address when you turn the server on.

### Timings

* It usually takes around 1 minute for Terraform to deploy all the components
* Upon the first deployment the server will take 5-10 minutes to become ready

### Backups

The server logic around backups is as follows:

1. Check if world exists locally and if so start the server using that
2. If no world exists, try to fetch from backup store and use that
3. If no backup world exists...? (TODO: Investigate way to automatically create new world)
4. Five minutes after the server has started perform a backup
5. Perform backups every hour after boot

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create the Sunkenland server | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type to run the server on (t3a.medium is the minimum size) | `string` | `"t3a.medium"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the deployment | `string` | `"prod"` | no |
| <a name="input_s3_lifecycle_expiration"></a> [s3\_lifecycle\_expiration](#input\_s3\_lifecycle\_expiration) | The number of days to keep files (backups) in the S3 bucket before deletion | `string` | `"90"` | no |
| <a name="input_server_password"></a> [server\_password](#input\_server\_password) | The server password | `string` | n/a | yes |
| <a name="input_sns_email"></a> [sns\_email](#input\_sns\_email) | The email address to send alerts to | `string` | n/a | yes |
| <a name="input_unique_id"></a> [unique\_id](#input\_unique\_id) | The ID of the deployment (used for tests) | `string` | `""` | no |
| <a name="input_world_name"></a> [world\_name](#input\_world\_name) | The Sunkenland world name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The S3 bucket name |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The EC2 instance ID |
| <a name="output_monitoring_url"></a> [monitoring\_url](#output\_monitoring\_url) | URL to monitor the Sunkenland Server |
| <a name="output_sunkenland_user_passwords"></a> [sunkenland\_user\_passwords](#output\_sunkenland\_user\_passwords) | List of AWS users and their encrypted passwords |
<!-- END_TF_DOCS -->
