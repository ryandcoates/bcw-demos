REGISTRY_NAME ?= registry.pheo.io
APPLICATION_NAME ?= webserver
 
build:
		 cd src; \
         docker build --tag ${REGISTRY_NAME}/${APPLICATION_NAME} .

push:
		cd src; \
		docker push ${REGISTRY_NAME}/${APPLICATION_NAME}

inf-up:
		cd iac; \
		pulumi up -s dev -y

inf-down:
		cd iac; \
		pulumi destroy -s dev -y