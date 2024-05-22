#!/bin/bash

echo ""
echo "Welcome to $DISTRO $VERSION builder"
echo ""

echo "export LANG=en_US.UTF-8" > /home/apssbuilder/.bash_profile
su - apssbuilder
