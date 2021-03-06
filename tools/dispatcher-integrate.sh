#!/bin/bash
##################################################################
# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Tool to help integrate dispatcher source code into
# a version of kubectl source code. This will update most
# of the code, but a few manual changes will be necessary
# as well. This script was first used to integrate kubectl
# version 1.11.7.
#
##################################################################

DISPATCHER_ORIGIN=${HOME}/go/src/github.com/GoogleCloudPlatform/kubectl-dispatcher/pkg
KUBECTL_DESTINATION=${HOME}/go/src/k8s.io/kubernetes/pkg/kubectl/dispatcher

echo "Make sure that you've created a branch"
echo

echo "Copying dispatcher into kubectl"

mkdir -p $KUBECTL_DESTINATION
cp -R $DISPATCHER_ORIGIN $KUBECTL_DESTINATION

echo "Updating dispatcher code imports"

PREV_DISPATCHER_IMPORT="github.com/GoogleCloudPlatform/kubectl-dispatcher"
NEW_DISPATCHER_IMPORT="k8s.io/kubernetes/pkg/kubectl/dispatcher"
find $KUBECTL_DESTINATION -name "*.go" | xargs sed -i -e "s|$PREV_DISPATCHER_IMPORT|$NEW_DISPATCHER_IMPORT|g"

echo "Updating genericclioptions flags"

PREV_CLI_IMPORT="k8s.io/cli-runtime/pkg/genericclioptions"
NEW_CLI_IMPORT="k8s.io/kubernetes/pkg/kubectl/genericclioptions"
find $KUBECTL_DESTINATION -name "*.go" | xargs sed -i -e "s|$PREV_CLI_IMPORT|$NEW_CLI_IMPORT|g"

echo "Updating logging..."

PREV_LOG_IMPORT="k8s.io/klog"
NEW_LOG_IMPORT="github.com/golang/glog"
find $KUBECTL_DESTINATION -name "*.go" | xargs sed -i -e "s|$PREV_LOG_IMPORT|$NEW_LOG_IMPORT|g"

PREV_LOG_INFO="klog.Info"
NEW_LOG_INFO="glog.V(5).Info"
find $KUBECTL_DESTINATION -name "*.go" | xargs sed -i -e "s|$PREV_LOG_INFO|$NEW_LOG_INFO|g"

PREV_LOG_WARNING="klog.Warning"
NEW_LOG_WARNING="glog.V(2).Info"
find $KUBECTL_DESTINATION -name "*.go" | xargs sed -i -e "s|$PREV_LOG_WARNING|$NEW_LOG_WARNING|g"

echo
echo "Finished"

