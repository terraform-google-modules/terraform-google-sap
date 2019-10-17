output "diskSize" {
  value = "${trimspace(data.local_file.test.content)}"
}
