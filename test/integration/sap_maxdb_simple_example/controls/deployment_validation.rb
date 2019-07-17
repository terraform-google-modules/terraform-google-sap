# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control 'deployment_validation' do

    describe command("gcloud compute instances get-serial-port-output #{attribute('instance_name')} --project=#{attribute('project_id')} --zone=#{attribute('zone')}") do
      its(:exit_status) { should eq 0 }

      context "output of df -h command" do
        its('stdout') { should match('meta-data=/dev/vg_maxdbroot/vol') }
        its('stdout') { should match('meta-data=/dev/vg_maxdbdata/vol') }
        its('stdout') { should match('meta-data=/dev/vg_maxdblog/vol') }
        its('stdout') { should match('meta-data=/dev/vg_maxdbbackup/vol') }
        its('stdout') { should match('meta-data=/dev/vg_usrsap/vol') }
        its('stdout') { should match('meta-data=/dev/vg_sapmnt/vol') }
      end

      context "INFO startup-script:" do
        its('stdout') { should match('Volume group "vg_swap" successfully created') }
        its('stdout') { should match('Logical volume "vol" created') }
      end
    end
  end
