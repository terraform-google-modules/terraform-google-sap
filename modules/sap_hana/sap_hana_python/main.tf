data "http" "sap-hana-py" {
  url = "https://storage.googleapis.com/sapdeploy/dm-templates/sap_hana/sap_hana.py"
}

resource "local_file" "sap-hana-py" {
  filename = "${path.module}/sap_hana.py"

  content = data.http.sap-hana-py.body
}

resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "python ${path.module}/wrapper.py ${var.instance-type} > ${local.memory_file}"
  }

  depends_on = [local_file.sap-hana-py]

  triggers = {
    sap-hana-py = data.http.sap-hana-py.body
    memory_file = local.memory_file
  }
}

locals {
  memory_file = "${path.module}/size-${var.instance-type}.txt"
}

data "local_file" "test" {
  filename = local.memory_file

  depends_on = [null_resource.test]
}
