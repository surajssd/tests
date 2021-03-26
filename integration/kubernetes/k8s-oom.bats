#!/usr/bin/env bats
#
# Copyright (c) 2020 Ant Group
#
# SPDX-License-Identifier: Apache-2.0
#

load "${BATS_TEST_DIRNAME}/../../.ci/lib.sh"
load "${BATS_TEST_DIRNAME}/../../lib/common.bash"
issue="https://github.com/kata-containers/tests/issues/3349"

setup() {
	skip "test not working, see ${issue}"
	export KUBECONFIG="$HOME/.kube/config"
	pod_name="pod-oom"
	get_pod_config_dir
}

@test "Test OOM events for pods" {
	skip "test not working, see ${issue}"
	wait_time=20
	sleep_time=2

	# Create pod
	kubectl create -f "${pod_config_dir}/pod-oom.yaml"

	# Check pod creation
	kubectl wait --for=condition=Ready pod "$pod_name"

	# Check if OOMKilled
	cmd="kubectl get pods "$pod_name" -o yaml | yq r - 'status.containerStatuses[0].state.terminated.reason' | grep OOMKilled"

	waitForProcess "$wait_time" "$sleep_time" "$cmd"
}

teardown() {
	skip "test not working, see ${issue}"
	# Debugging information
	kubectl describe "pod/$pod_name"

	kubectl delete pod "$pod_name"
}
