ENV = $1
REGION = $2
BUCKET_NAME = $3
PROFILE = $4
CD = [[ -d envs/${ENV}/${REGION} ]] && cd envs/${ENV}/${REGION}

init:
	@${CD} && \
    terraform init \
	-reconfigure \
	-backend=true \
	-backend-config="bucket=${BUCKET_NAME}" \
	-backend-config="key=${ENV}/terraform.tfstate" \
	-backend-config="region=${REGION}" \
	-backend-config="profile=${PROFILE}" \

plan:
	@${CD} && terraform plan -out=tfplan

apply:
	@${CD} && terraform apply tfplan

destroy:
	@${CD} && terraform destroy