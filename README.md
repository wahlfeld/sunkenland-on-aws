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

* MacOS required to run this code (or Linux, but will require some fiddling around)
* AWS account including CLI configured on your machine
* Terraform

## Usage

1. Create a Terraform backend S3 bucket to store your state files
2. Copy and paste the `template` folder somewhere on your computer
3. Configure `terraform.tf` to point at the S3 bucket you just created
4. Create a file called `terraform.tfvars` as per the input descriptions in `inputs.tf` E.g.

```
aws_region       = "ap-southeast-2"    // Choose a region closest to your physical location
server_region    = "asia"
sns_email        = "mrsmith@gmail.com" // Alerts go here e.g. server stopped
world_name       = "supercheapworld"
server_password  = "nohax"
```

5. Run `terraform init && terraform apply`

### Example folder structure

```
sunkenland-on-aws           // (this project)
└── your-sunkenland-server  // (create me)
    ├── inputs.tf           // (copied from ./template)
    ├── main.tf             // (copied from ./template)
    ├── outputs.tf          // (copied from ./template)
    ├── terraform.tf        // (copied from ./template)
    └── terraform.tfvars    // (create me, example above)
```

### Monitoring

To view server monitoring metrics visit the `monitoring_url` output from
Terraform after deploying. Note that this URL will change every time the
server starts -- I find it's easier to just take note of the public IP
address when you turn the server on.

### Timings

* It usually takes <1 minute for Terraform to deploy all the components
* Upon the first deployment the server will take 5-10 minutes to become ready

### Backups

The server logic around backups is as follows:

1. Check if world exists locally and if so start the server using that
2. If no world exists locally create a new one
4. Five minutes after the server has started perform a backup
5. Perform backups every hour after boot

NOTE: Restoring worlds from backups is a manual process. It is the same
process as providing your own world (section below).

### Provide your own world

It is possible to provide your own world but this is a manual process.

1. Create the server per above instructions
2. Initially a blank world will be provided for you automatically
3. You need to replace this world with your own, which will need to be done
manually on the running server. I recommend using AWS SSM to do this, as it
is best practice and already supported by the server.
4. Using the instance ID (see the Terraform outputs), run a command similar
to the one below. Note, I am assuming you already have the SSM client installed
on your computer.
```
aws ssm start-session --target i-0faf615a7c184bab5
```
5. This will create a remote terminal session with the server. Navigate to
`/home/slserver/sunkenland/Worlds` (`cd /home/slserver/sunkenland/Worlds`)
and then shutdown the Sunkenland service (`systemctl stop sunkenland`).
6. Edit each world file using a text editor like `vi`. You can just replace
everything in each file with the contents of your own world files. Recall
the world files are called `StartGameConfig.json`, `World.json`, and
`WorldSetting.json`.
7. Restart the server (`systemctl start sunkenland`), wait a minute, then
check the server logs to make sure there are no errors
(`tail -n 1000 -f ./sunkenland.log`)
8. If you see a log like `Server Start Complete, Ready for Clients to Join.`
then it's likely the server is ready to go. I suggest you take a quick look
for any errors in the logs above just in case.

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
| <a name="input_death_penalties"></a> [death\_penalties](#input\_death\_penalties) | n/a | `bool` | `true` | no |
| <a name="input_enemy_difficulty"></a> [enemy\_difficulty](#input\_enemy\_difficulty) | n/a | `number` | `1` | no |
| <a name="input_enemy_garrison_difficulty"></a> [enemy\_garrison\_difficulty](#input\_enemy\_garrison\_difficulty) | n/a | `number` | `2` | no |
| <a name="input_enemy_raid_difficulty"></a> [enemy\_raid\_difficulty](#input\_enemy\_raid\_difficulty) | n/a | `number` | `2` | no |
| <a name="input_flag_shared"></a> [flag\_shared](#input\_flag\_shared) | n/a | `bool` | `true` | no |
| <a name="input_friendly_fire"></a> [friendly\_fire](#input\_friendly\_fire) | n/a | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type to run the server on (2 vCPUs / 8 GiB minimum) | `string` | `"t3a.large"` | no |
| <a name="input_loot_respawn_time_in_days"></a> [loot\_respawn\_time\_in\_days](#input\_loot\_respawn\_time\_in\_days) | n/a | `number` | `4` | no |
| <a name="input_map_shared"></a> [map\_shared](#input\_map\_shared) | n/a | `bool` | `true` | no |
| <a name="input_max_players"></a> [max\_players](#input\_max\_players) | n/a | `number` | `10` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the deployment | `string` | `"prod"` | no |
| <a name="input_random_spawn_points"></a> [random\_spawn\_points](#input\_random\_spawn\_points) | n/a | `bool` | `false` | no |
| <a name="input_research_shared"></a> [research\_shared](#input\_research\_shared) | n/a | `bool` | `true` | no |
| <a name="input_respawn_time"></a> [respawn\_time](#input\_respawn\_time) | n/a | `number` | `10` | no |
| <a name="input_s3_lifecycle_expiration"></a> [s3\_lifecycle\_expiration](#input\_s3\_lifecycle\_expiration) | The number of days to keep files (backups) in the S3 bucket before deletion | `string` | `"90"` | no |
| <a name="input_server_password"></a> [server\_password](#input\_server\_password) | The server password | `string` | `""` | no |
| <a name="input_server_region"></a> [server\_region](#input\_server\_region) | The region to host the Sunkenland server | `string` | `"asia"` | no |
| <a name="input_session_visible"></a> [session\_visible](#input\_session\_visible) | n/a | `bool` | `true` | no |
| <a name="input_sns_email"></a> [sns\_email](#input\_sns\_email) | The email address to send alerts to | `string` | n/a | yes |
| <a name="input_spawn_point_shared"></a> [spawn\_point\_shared](#input\_spawn\_point\_shared) | n/a | `bool` | `true` | no |
| <a name="input_survival_difficulty"></a> [survival\_difficulty](#input\_survival\_difficulty) | n/a | `number` | `1` | no |
| <a name="input_unique_id"></a> [unique\_id](#input\_unique\_id) | The ID of the deployment (used for tests) | `string` | `""` | no |
| <a name="input_world_description"></a> [world\_description](#input\_world\_description) | n/a | `string` | `""` | no |
| <a name="input_world_name"></a> [world\_name](#input\_world\_name) | Name of the server shown in the Sunkenland server browser | `string` | `"template"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The S3 bucket name |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The EC2 instance ID |
| <a name="output_monitoring_url"></a> [monitoring\_url](#output\_monitoring\_url) | URL to monitor the Sunkenland Server |
<!-- END_TF_DOCS -->
