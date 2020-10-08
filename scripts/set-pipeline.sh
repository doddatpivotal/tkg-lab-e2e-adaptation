set -e

ytt -f concourse/pipeline/secrets.yaml -f local-config/values.yaml --ignore-unknown-comments | kapp deploy -n concourse-main -a concourse-main-secrets -y -f -

fly -t stormsend set-pipeline -p petclinic -c concourse/pipeline/spring-petclinic.yaml -n

