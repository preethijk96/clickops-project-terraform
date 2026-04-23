output "public_ip" {
  value = module.ec2.public_ip
}
output "instance_profile" {
 value = aws_iam_instance_profile.profile.name
}