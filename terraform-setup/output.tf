


output "downstream_ips" {
	value = aws_instance.downstreams.*.public_ip
}

output "downstream_count" {
	value = var.downstream_count
}

output "rancher_url" {
	
	value = trimsuffix(format("%s.%s", var.rancher_subdomain, var.domain), ".")
}

output "rancher_access_token" {
	value = var.rancher_access_token
}

