env=dev
project=shared

# Azure credentials
AZURE_CREDENTIALS=$(cat AZURE_CREDENTIALS.json)

export ARM_CLIENT_ID=$( jq -r '.clientId' <<< $AZURE_CREDENTIALS )
export ARM_CLIENT_SECRET=$( jq -r '.clientSecret' <<< $AZURE_CREDENTIALS )
export ARM_SUBSCRIPTION_ID=$( jq -r '.subscriptionId' <<< $AZURE_CREDENTIALS )
export ARM_TENANT_ID=$( jq -r '.tenantId' <<< $AZURE_CREDENTIALS )
export ARM_ACCESS_KEY=$( jq -r '.accessKey' <<< $AZURE_CREDENTIALS )

# Github Variables
GH_REPO_NAME=azure_infra
GH_REPO_OWNER=Estanz0

GH_CREDENTIALS=$(cat GH_CREDENTIALS.json)
export GITHUB_TOKEN=$( jq -r '.PAT_TOKEN' <<< $GH_CREDENTIALS )

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az account set -s $ARM_SUBSCRIPTION_ID

terraform -chdir=deploy init
terraform -chdir=deploy fmt
terraform -chdir=deploy workspace select -or-create=true $env$project

terraform -chdir=deploy plan -input=false -var-file $env.tfvars -var env=$env -var project_id=$project -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET -var subscription_id=$ARM_SUBSCRIPTION_ID -var tenant_id=$ARM_TENANT_ID -var gh_repo_owner=$GH_REPO_OWNER -var gh_repo_name=$GH_REPO_NAME