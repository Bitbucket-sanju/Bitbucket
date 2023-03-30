module "project" {
    source = "../Modules"
    vpc_cidr = "10.0.0.0/16"
    v_vpc_id = module.project.v_vpc_id
    v_sn1 = module.project.v_sn1
    v_sn2 = module.project.v_sn2
    az = module.project.az
}