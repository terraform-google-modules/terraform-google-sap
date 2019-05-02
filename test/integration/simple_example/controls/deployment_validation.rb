# Copyright 2018 Google LLC
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

# Copyright 2018 Google LLC
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

require 'retriable'

control 'deployment_validation' do
  describe 'console output of startup script' do
    # Avoid racing against the instance boot sequence
    before :all do
      Retriable.retriable(tries: 2) do
        get_serial_port_output = "gcloud compute instances get-serial-port-output #{attribute('instance_name')}"
        @cmd = command("#{get_serial_port_output} --project #{attribute('project_id')}")
        if not %r{Startup finished}.match(@cmd.stdout)
          raise StandardError, "Not found: 'systemd: Startup finished' in console output, cannot proceed"
        end
      end
    end

    subject do
      @cmd
    end

    describe "Verify /hana directories" do
      its('exit_status') { should be 0 }
      its('stdout') { should match('/hana/data & /hana/log') }
    end

    #describe "Verify HANA services are running" do
      #its('stdout') { should match('TEST UUID E62A3897-AAA0-4577-A564-F00B4B54869B') }
      #its('stdout') { should match('Finished with startup-script-custom example 3FF02EC9-BFFE-4B47-BEE7-C98A07818251') }
    #end

  end
end