variable "cluster_name" {
  description = "The kind cluster name."
    type        = string
  default     = "tpnyblair-cluster"

}

variable "node_image" {
  description = "The kind node image to use."
    type        = string
  default     = "kindest/node:v1.27.3"
  
}
variable "kind_version" {
  description = "The kind version of kubernetes."
    type        = string
  default     = "v1.27.3"

}
