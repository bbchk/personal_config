#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

set -euo pipefail

# ====================================

confirm "Do you want to move default XDG directories?" do_xdg_move
if $do_xdg_move; then
  echo "Moving XDG directories..."
  # Create new xdg directories
  mkdir -p "$HOME/pers/xdg"
  mkdir -p "$HOME/downloads"

  mv "$HOME/Desktop" "$HOME/pers/xdg/Desktop"
  mv "$HOME/Documents" "$HOME/pers/xdg/Documents"
  mv "$HOME/Music" "$HOME/pers/xdg/Music"
  mv "$HOME/Pictures" "$HOME/pers/xdg/Pictures"
  mv "$HOME/Public" "$HOME/pers/xdg/Public"
  mv "$HOME/Templates" "$HOME/pers/xdg/Templates"
  mv "$HOME/Videos" "$HOME/pers/xdg/Videos"
  mv "$HOME/Downloads" "$HOME/downloads"
  echo "Finished moving directories."
else
  echo "Skipping XDG directory move."
fi


confirm "Do you want to clone frequently used projects?" do_clone_projects
if $do_clone_projects; then
  echo "Cloning frequently used projects..."
  # Clone frequently worked on projects

  mkdir -p "$HOME/dev/my"
  my_repos=(jv-fr avkfe scrape lvfe live lvbe lvops train slugtrans)
  for r in "${my_repos[@]}"; do
    git clonew "git@github.com:bbchk/${r}.git" "$HOME/dev/my/$r"
  done

  mkdir -p "$HOME/dev/ib"
  ib_repos=(
  patient-portal/appointments
  healthone/appointmentservice
  smb-portal/billing-invoicing
  healthone/BOS
  healthone/ui/business-portal
  cp/client/call-log
  bbuchok/catalog-test
  smb-platform-services/cdn
  df-smb-devops/helmcharts/cx/cache-service
  df-smb-devops/helmcharts/cdn
  df-smb-devops/helmcharts/integration
  df-smb-devops/helmcharts/provider
  df-smb-devops/helmcharts/secure-forms
  df-smb-devops/helmcharts/secure-messaging
  df-smb-devops/helmcharts/sonarqube10
  df-smb-devops/helmchart-prod/secure-forms
  df-smb-devops/helmchart-stg/secure-forms
  df-smb-devops/helmchart-stg/secure-messaging
  smb-portal/clamav-ds
  healthone/consumerservice/consumer-api-v2
  yggdrasil/consumer-portal
  smb/dns
  developer-platform/docker-base
  smb/document-store
  smb/domreg
  cp/smbdesk/electrodesk
  healthone/elasticsearch-indexer
  smb/encryptor
  ike-migrations/forno
  smb-portal/standalone/webmd/ga-campaign
  smb-portal/standalone/webmd/ga-overview
  developer-platform/vendor-images/gitlab-cli
  cp/devops/gitlab-templates
  df-smb-devops/helmcharts/elasticsearch-indexer
  df-smb-devops/helmcharts/form-leads
  developer-platform/helm-charts/helm-provisioner-shims/hop-provisioner
  smb/ibconnect-client
  df/ib-graph
  df/ib-graph-gateway
  corp/levelup/ib-learning-paths
  cp/ib-not-a-robot
  developer-platform/scripts/ike-cleaner
  healthone/sonarqube
  developer-platform/minimal-examples/ike-laravel-examples
  developer-platform/ike-migrator
  developer-platform/helm-charts/ike-service
  bbuchok/ike-sonarqube
  healthone/integration
  smb-platform-services/iss-checker
  developer-platform/jenkins-build-helpers
  developer-platform/ike/ike-standards/job-server-configuration
  developer-platform/k8s-deploy
  developer-platform/vendor-images/k8s-wait-for
  smb/kiosk
  smb/larb
  smb/leads
  healthone/live-app-server
  smb-platform-services/live-pop-hooks
  smb/pms-adjudicator
  smb/pms-writeback
  smb/secure-forms
  healthone/provider-service
  df/rules-engine
  smb/secure-forms-html-templates
  smb/secure-messaging
  healthone/segmentation
  healthone/service-client/service-client
  developer-platform/shared-manifests
  developer-platform/ship_it
  df/shorten-url-api
  patient-portal/signup-api
  smb/skynet
  smb-portal/standalone/smbp-ca
  smb-portal/smb-portal
  yggdrasil/smb-sequencer
  smb-platform-services/smb-websockets
  developer-platform/helm-charts/provisioners/solr-provisioner
  bbuchok/sonarqube-shared-component
  cp/bff/text-to-pay
  healthone/userservice
  developer-platform/vendor-images/dind
  developer-platform/vendor-images/docker
  developer-platform/vendor-images/memcached
  smb/webhook-tester
  smb-portal/webscoket-client
  healthone/websocket-service
  smb/yggdrasil
  healthone/cache-service
  developer-platform/ci-cd-gitlab-manifests
  )

  for r in "${ib_repos[@]}"; do
    git clonew "git@git.internetbrands.com:${r}.git" "$HOME/dev/ib/$r"
  done
  echo "Finished cloning projects."
else
    echo "Skipping project cloning."
fi
