variable "region" {
  description = "Provide AWS region that you will deploy resources"
}

variable "token" {
  description = "Provide your GitHub Token generated for repository access"
}


variable "db_username" {
  description = "Provide Database username"
}

variable "db_password" {
  description = "Provide Database password"
}

variable "database_name" {
  description = "Provide Database name"
}

variable "db_instance_class" {
  description = "Provide Database instance class"
}

variable "load_balancer_type" {
  description = "Provide load balancer type"
}

variable "repo_name" {
    description = "Provide GitHub repository name"  
}