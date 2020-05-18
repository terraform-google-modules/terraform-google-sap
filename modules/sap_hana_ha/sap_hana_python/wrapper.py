# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sap_hana
import sys


class Context:
    def __init__(self, instance_type):
        self.properties = {
            "zone": "",
            "subnetwork": "",
            "publicIP": "",
            "instanceName": "",
            "instanceType": instance_type,
            "linuxImage": "",
            "linuxImageProject": "",
            "sap_hana_scaleout_nodes": 0,
        }
        self.env = {
            "project": "",
            "project_number": "",
        }


if __name__ == '__main__':
    instance_type = sys.argv[1]

    context = Context(instance_type)

    resources = sap_hana.GenerateConfig(context)['resources']

    diskSSD = next((sub for sub in resources if sub['name'] == '-pdssd'))
    diskHDD = next((sub for sub in resources if sub['name'] == '-backup'))
    print(diskSSD['properties']['sizeGb'])
    print(diskHDD['properties']['sizeGb'])
