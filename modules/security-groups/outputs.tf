output "cluster_security_group_id" {
  value = aws_security_group.cluster_sg.id
}

output "node_security_group_id" {
  value = aws_security_group.node_sg.id
}
