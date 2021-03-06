#!/bin/sh

echo Welcome to fabric8: http://fabric8.io/
echo
echo Starting Fabric8 container: $FABRIC8_KARAF_NAME 
echo Executing Java main: $FABRIC8_JAVA_MAIN
echo ZooKeeper: $FABRIC8_ZOOKEEPER_URL using environment: $FABRIC8_FABRIC_ENVIRONMENT

# TODO allow this to be disabled via an env var
service sshd start

echo "executing java $FABRIC8_JAVA_AGENT $FABRIC8_JVM_ARGS -cp "lib/*" $FABRIC8_JAVA_MAIN $FABRIC8_MAIN_ARGS"
java $FABRIC8_JAVA_AGENT $FABRIC8_JVM_ARGS -cp "lib/*" $FABRIC8_JAVA_MAIN $FABRIC8_MAIN_ARGS
