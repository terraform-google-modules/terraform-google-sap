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

package sap_hana_scaleout

import (
	"fmt"
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-sap/test/integration/common"
)

func TestSapHanaScaleoutModule(t *testing.T) {
	sapHanaSc := tft.NewTFBlueprintTest(t)

	sapHanaSc.DefineVerify(func(assert *assert.Assertions) {
		sapHanaSc.DefaultVerify(assert)

		instanceSelfLinks := make(map[string]string)
		instanceSelfLinks["primary"] = sapHanaSc.GetStringOutput("sap_hana_primary_self_link")
		workers := terraform.OutputList(t, sapHanaSc.GetTFOptions(), "hana_scaleout_worker_self_links")
		for i, workerLink := range workers {
			instanceSelfLinks[fmt.Sprintf("worker-%d", i)] = workerLink
		}

		standyListRaw := sapHanaSc.GetStringOutput("hana_scaleout_standby_self_links")
		standbys := strings.Split(strings.Trim(standyListRaw, "[]"), ",")
		for i, standbyLink := range standbys {
			instanceSelfLinks[fmt.Sprintf("standby-%d", i)] = standbyLink
		}

		// assert instance configurations
		for insType, insSelfLink := range instanceSelfLinks {
			zone, name := common.GetInstanceNameAndZone(insSelfLink)
			op := gcloud.Runf(t, "compute instances describe %s --zone %s --project %s", name, zone, sapHanaSc.GetTFSetupStringOutput("project_id"))
			assert.Equal("n1-standard-16", common.GetInstanceMachineType(op.Get("machineType").String()), fmt.Sprintf("%s machine type set as n1-highmem-32", insType))
			insNetworkInterface := op.Get("networkInterfaces").Array()[0]
			assert.Equal("default", common.GetInstanceNetworkName(insNetworkInterface.Get("network").String()), fmt.Sprintf("%s instance connected to default network", insType))
			subnetRegion, subnetName := common.GetInstanceSubnetNameAndRegion(insNetworkInterface.Get("subnetwork").String())
			assert.Equal("default | us-east1", subnetName+" | "+subnetRegion, fmt.Sprintf("%s instance connected to default subnet in the us-east1 region", insType))
		}
	})

	sapHanaSc.Test()
}
