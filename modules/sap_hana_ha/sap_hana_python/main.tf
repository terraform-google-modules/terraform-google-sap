/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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
