output "vpc_id" {
    value = aws_vpc.myvpc.id
}

output "public_subnet_id" {
    value = aws_subnet.mypublic.id
}

output "private_subnet_id" {
    value = aws_subnet.myprivate.*.id
}

output "Public_SG_id" {
    value = aws_security_group.Public_SG.id
}

output "Private_SG_id" {
    value = aws_security_group.Private_SG.id
}