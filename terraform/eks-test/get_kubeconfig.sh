#!/usr/bin/env bash

terraform output kubeconfig > $HOME/.kube/eks-test-config
alias eks-test="kubectl --kubeconfig=$HOME/.kube/eks-test-config"