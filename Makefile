SHELL:= /bin/bash

IMAGE=registry-1-stage.docker.io/keijayk/techchallengeapp:dev23

all:    init build-image push-image deploy

init:
	terraform -chdir=terraform init

build:
	./build.sh

build-image: build
	docker build -f Dockerfile -t $(IMAGE) .

push-image:
	docker push $(IMAGE)

deploy:
	terraform -chdir=terraform apply -auto-approve

clean:
	cd terraform
	rm -rf .terraform terraform.tfstate  terraform.tfstate.backup TechChallengeApp
	cd ..
	
destroy: 
	terraform -chdir=terraform destroy -auto-approve