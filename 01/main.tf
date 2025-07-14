resource "local_file" "mi_primer_archivo" {
  filename = "hola-terraform.txt"
  content  = "¡Hola! ¿Cómo estás mi niño?"
}