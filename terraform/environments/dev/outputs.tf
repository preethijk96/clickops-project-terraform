output "public_ip" {
  value = module.ec2.public_ip
}

output "instance_profile" {
  value = module.iam.instance_profile
}