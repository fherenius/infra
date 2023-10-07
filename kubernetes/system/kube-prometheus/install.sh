#! /bin/bash
helm upgrade \
  --install \
  --create-namespace \
  --namespace monitoring \
  --wait \
  --atomic \
  kube-prometheus \
  .