set -e

ytt -f concourse/pipeline/secrets.yaml -f $PARAMS_YAML --ignore-unknown-comments | kapp deploy -n concourse-main -a concourse-main-secrets -y -f -

fly -t $(yq r $PARAMS_YAML commonSecrets.concourseAlias) set-pipeline -p petclinic -c concourse/pipeline/spring-petclinic.yaml -n

