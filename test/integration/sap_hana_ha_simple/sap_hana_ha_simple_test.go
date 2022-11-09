// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package sap_hana_ha_simple

import (
	"fmt"
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func getInstanceNameAndZone(insSelfLink string) (string, string) {
	instanceMd := insSelfLink[strings.LastIndex(insSelfLink, "zones/")+6:]
	instanceMdList := strings.Split(instanceMd, "/")

	return instanceMdList[0], instanceMdList[2]
}

func getInstanceMachineType(machineTypeLink string) string {
	machineType := machineTypeLink[strings.LastIndex(machineTypeLink, "/")+1:]
	return machineType
}

func getInstanceNetworkName(networkLink string) string {
	networkName := networkLink[strings.LastIndex(networkLink, "/")+1:]
	return networkName
}

func getInstanceSubnetNameAndRegion(subnetLink string) (string, string) {
	subnetMd := subnetLink[strings.LastIndex(subnetLink, "regions/")+8:]
	subnetMdList := strings.Split(subnetMd, "/")

	return subnetMdList[0], subnetMdList[2]
}

func TestSapHanaHaSimpleModule(t *testing.T) {
	sapHanaHa := tft.NewTFBlueprintTest(t)

	sapHanaHa.DefineVerify(func(assert *assert.Assertions) {
		sapHanaHa.DefaultVerify(assert)

		instanceSelfLinks := make(map[string]string)
		instanceSelfLinks["primary"] = sapHanaHa.GetStringOutput("sap_hana_ha_primary_instance_self_link")
		instanceSelfLinks["secondary"] = sapHanaHa.GetStringOutput("sap_hana_ha_secondary_instance_self_link")

		// assert instance configurations
		for insType, insSelfLink := range instanceSelfLinks {
			zone, name := getInstanceNameAndZone(insSelfLink)
			op := gcloud.Runf(t, "compute instances describe %s --zone %s --project %s", name, zone, sapHanaHa.GetTFSetupStringOutput("project_id"))
			assert.Equal("n1-highmem-32", getInstanceMachineType(op.Get("machineType").String()), fmt.Sprintf("%s machine type set as n1-highmem-32", insType))
			insNetworkInterface := op.Get("networkInterfaces").Array()[0]
			assert.Equal("default", getInstanceNetworkName(insNetworkInterface.Get("network").String()), fmt.Sprintf("%s instance connected to default network", insType))
			subnetRegion, subnetName := getInstanceSubnetNameAndRegion(insNetworkInterface.Get("subnetwork").String())
			assert.Equal("default | us-east1", subnetName+" | "+subnetRegion, fmt.Sprintf("%s instance connected to default subnet in the us-east1 region", insType))
		}
	})

	sapHanaHa.Test()
}
