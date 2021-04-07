variable "hostname" {
  default = "Ubuntu20.04"
}

variable "image" {
  default = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "imageUbuntu18" {
  default = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
}

variable "domain" {
  default = "danand.xyz"
}

variable "memory" {
  default = 1024
}

variable "cpu" {
  default = 1
}
