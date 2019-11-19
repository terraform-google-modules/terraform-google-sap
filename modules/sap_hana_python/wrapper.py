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

  out = sap_hana.GenerateConfig(context)

  print(out['resources'][0]['properties']['sizeGb'])
