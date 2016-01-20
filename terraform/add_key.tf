# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "${var.USER_NAME}"
    tenant_name = "${var.TENANT_SSD_XPLAT_NAME}"
    tenant_id = "${var.TENANT_SSD_XPLAT_ID}"
    password  = "${var.password}"
    auth_url  = "${var.AUTH_URL}"
}
resource "openstack_compute_keypair_v2" "harvinder-keypair" {
  region = "${var.REGION_GBR_FXBO_NAME}"
  name = "harvinder-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfFzk6uxfzNqgWtUTeM6wAs27DPR3e35F2c3BufuRKoyQCgkQmMFm8YzdaUlyVs7RE9T2dRkzxnwhIGAIcx7zQ0n5YF2zUcNE8/pdTcmN9jhmIP8EKa92u5iF2WAI+mghbHR5FbFMPpiXsTgXCK8u2ZAnrZGWdBxSKSpNAAjwqNQHBlRnqkF13pwNLBdyCePUQqiMl3AJ7Tvw4tcIfRrgzaa1XtOtGlUPKmNQ7vd5oBVaZxIFiHPRNnTkliqOnjBjNdIvodAXuK1IQfMST8FkON6Nk9fE/qm/3f4KYInLgzvyGyEDd+iFb4gN5QyO57voIdGnwkGcLevkYBVWjOabT hsingh006c@PATAPL-72QVG3QP"
}
