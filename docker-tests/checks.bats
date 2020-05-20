#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests
run_only_test() {
  if [[ "$SUT_IP" != "$1" ]] && [[ "$SUT_IP" != "$2" ]] && [[ "$SUT_IP" != "$2" ]]; then
    skip
  fi
}

#setup() {
#  run_only_test "172.18.0.3" "172.18.0.4" "172.18.0.5"
#}


@test 'Promtail listens 6922' {
  run bash -c "curl http://${SUT_IP}:6922/metrics"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'log_messages_total' ]]
}

@test 'Promtail config file exists' {
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/oio/sds/TRAVIS/promtail-0/config.yml"
  echo "output: "$output
  [[ "${status}" -eq "0" ]]
}

@test 'Promtail configuration file is valid YAML' {
    run bash -c "docker exec -ti ${SUT_ID} find /etc/oio/sds/TRAVIS/promtail-0/ -name \*.yml -exec python -c \
    'import sys,yaml; yaml.load(open(sys.argv[1]).read(), Loader=yaml.SafeLoader);' {} \;"
    echo "output: "$output
    [[ "${output}" -eq "" ]]
}
