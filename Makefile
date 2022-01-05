SHELL:= /bin/bash

IMAGE=techchallengeapp:dev

all:  init build-image deploy

init:
	terraform -chdir=terraform init

build:
	./build.sh

build-image: build
	docker build -f Dockerfile -t $(IMAGE) .

deploy:
	terraform -chdir=terraform apply -auto-approve

clean:
	cd terraform
	rm -rf .terraform terraform.tfstate  terraform.tfstate.backup TechChallengeApp
	cd ..
	
destroy: 
	terraform -chdir=terraform destroy -auto-approve