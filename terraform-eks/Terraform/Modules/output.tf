output "v_vpc_id"{
   value=aws_vpc.vpc1.id
}
output "v_sn1"{
   value=aws_subnet.pub-sub.*.id
}
output "v_sn2" {
   value = aws_subnet.prv-sub.*.id
}
output "az" {

  value = data.aws_availability_zones.az1.names
  
}