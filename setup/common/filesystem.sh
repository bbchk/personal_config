#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

# ====================================

log "Relocating standard XDG user directories to a centralized persistent storage path."
mv "$HOME/Desktop" "$HOME/pers/xdg/desktop"
mv "$HOME/Documents" "$HOME/pers/xdg/documents"
mv "$HOME/Music" "$HOME/pers/xdg/music"
mv "$HOME/Pictures" "$HOME/pers/xdg/pictures"
mv "$HOME/Public" "$HOME/pers/xdg/public"
mv "$HOME/Templates" "$HOME/pers/xdg/templates"
mv "$HOME/Videos" "$HOME/pers/xdg/videos"
mv "$HOME/Downloads" "$HOME/pers/xdg/downloads"
xdg-user-dirs-update

log "Cloning personal projects and Liveworld repositories from GitHub and GitLab."
mkdir -p "$HOME/dev/my"

gh_repos=(jv-fr avkfe scrape lvfe live lvbe lvops train slugtrans)
for r in "${gh_repos[@]}"; do
  git clone "git@github.com:bbchk/${r}.git" "$HOME/dev/my/$r"
done

gl_repos=(odoo docker ci_cd cert_manager)
for r in "${gl_repos[@]}"; do
  git clone "git@gitlab.com:liveworld/${r}.git" "$HOME/dev/my/liveworld_$r"
done

log "Provisioning IB repositories projects."
mkdir -p "$HOME/dev/ib"
ib_repos=(
    cp/online-booking/booking-app
    cp/online-booking/booking-setting-app
    smb-portal/online-booking
    patient-portal/appointments
    healthone/appointmentservice
    smb-portal/billing-invoicing
    healthone/BOS
    healthone/ui/business-portal
    cp/client/call-log
    smb-platform-services/cdn
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
    smb/ibconnect-client
    df/ib-graph
    df/ib-graph-gateway
    corp/levelup/ib-learning-paths
    cp/ib-not-a-robot
    developer-platform/scripts/ike-cleaner
    healthone/sonarqube
    developer-platform/minimal-examples/ike-laravel-examples
    developer-platform/ike-migrator
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
    df/consumer-business-directory-app
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
    df-smb-devops/helmcharts/elasticsearch-indexer
    df-smb-devops/helmcharts/form-leads
    developer-platform/helm-charts/helm-provisioner-shims/hop-provisioner
    developer-platform/helm-charts/ike-service
    developer-platform/helm-charts/provisioners/solr-provisioner
)

# for r in "${ib_repos[@]}"; do
#   dest_name="${r//\//_}"
#   log "Cloning $r as $dest_name"
#   git clone "git@git.internetbrands.com:${r}.git" "$HOME/dev/ib/$dest_name"
# done
