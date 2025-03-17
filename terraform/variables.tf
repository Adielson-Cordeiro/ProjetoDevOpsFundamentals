variable "vm_count" {
  description   = "Número de VMs a serem criadas"
  type          = number
  default       = 4
}

variable "vm_base_name" {
  description   = "Nome base das VMs"
  type          = string
  default       = "vm"
}

variable "vm_size" {
  description   = "Tamanho das VMs"
  type          = string
  default       = "Standard_B1s"
}

variable "admin_username" {
  description   = "Usuário administrador das VMs"
  type          = string
  default       = "adminuser"
}

variable "admin_password" {
  description   = "Senha do administrador"
  type          = string
  sensitive     = true
  default       = "#vmKONAN321"
}

variable "location" {
  description   = "Região onde os recuros serão criados"
  type          = string
  default       = "brazilsouth"
}

variable "slq_admin_username" {
  description   = "Nome do usúario administrador do SQL Server"
  type          = string
  default       = "sqladmin"
}

variable "slq_admin_password" {
  description   = "Senha do administrador do SQL Server"
  type          = string
  sensitive     = true
  default       = "#bancoANIMAL123"
}

variable "sql_database_name" {
  description   = "Nome do banco de dados SQL"
  type          = string
  default       = "meubancodedados"
}

variable "sql_server_name" {
  description   = "Nomde do SQL Server"
  type          = string
  default       = "sql-server-projetodevops"
}
