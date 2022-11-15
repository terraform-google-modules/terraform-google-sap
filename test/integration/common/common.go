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

package common

import "strings"

func GetInstanceNameAndZone(insSelfLink string) (string, string) {
	instanceMd := insSelfLink[strings.LastIndex(insSelfLink, "zones/")+6:]
	instanceMdList := strings.Split(instanceMd, "/")

	return instanceMdList[0], instanceMdList[2]
}

func GetInstanceMachineType(machineTypeLink string) string {
	machineType := machineTypeLink[strings.LastIndex(machineTypeLink, "/")+1:]
	return machineType
}

func GetInstanceNetworkName(networkLink string) string {
	networkName := networkLink[strings.LastIndex(networkLink, "/")+1:]
	return networkName
}

func GetInstanceSubnetNameAndRegion(subnetLink string) (string, string) {
	subnetMd := subnetLink[strings.LastIndex(subnetLink, "regions/")+8:]
	subnetMdList := strings.Split(subnetMd, "/")

	return subnetMdList[0], subnetMdList[2]
}
