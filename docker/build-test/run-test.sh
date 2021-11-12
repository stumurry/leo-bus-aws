#!/bin/bash

composefile=docker/build-test/docker-compose.yml

trap "./local down build-test >/dev/null 2>&1 &" 0 1 2 3 14 15
./local down build-test

dc() {
  echo ""
  echo ">>> docker-compose -f $composefile $@"
  echo ""
  docker-compose -f $composefile "$@" || {
    echo "FAILED docker-compose -f $composefile $@"
    exit 1
  }
  return 0
}

if [ ! -e ~/.aws ]; then
    # strip out the aws creds import, not used on jenkins
    echo "not importing ~/.aws"
    mv $composefile $composefile.bak
    sed -e s%~/.aws:/root/.aws:%~/.aws:/root/.aws_imported:% $composefile.bak > $composefile
fi

./local build build-test &&
  ./local up build-test -d &&
  dc exec -T db /bin/bash -c '/data/setup-db.sh bluesun dev < /dev/null' &&
  dc run leo-bus /bin/sh -c 'npm test'

status=${PIPESTATUS[3]}
echo "status=> $status"
exit $status
