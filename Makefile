NAME=$(shell basename `git rev-parse --show-toplevel`)
VERSION=v0.1.0



# Derivations
CLUSTER_NAME=$(shell basename ${PWD})
IMAGE=${USERNAME}/${NAME}:${VERSION}



# Local app development targets
build:
	@cd app && go build .

build-image:
	@cd app && docker image build --build-arg VERSION=${VERSION} --tag ${IMAGE} .

check-chart:
	@helm lint charts/${NAME}
	@# We need to use an alternative schema location, see https://github.com/instrumenta/kubernetes-json-schema/issues/26
	@# For k8s version, see https://github.com/kubernetes/kubernetes/releases
	@helm template charts/${NAME} | \
		kubeval --kubernetes-version 1.21.1 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master --strict
run:
	@./app/${NAME} &

run-container:
	@docker container run --name ${NAME} --detach -p 5000:5000 ${IMAGE}

show-container-logs:
	@docker container logs ${NAME}

stop:
	@pkill ${NAME}

stop-container:
	@docker container rm --force ${NAME}



# k8s cluster targets
install-argocd:
	@# See https://argoproj.github.io/argo-cd/getting_started/#1-install-argo-cd
	@kubectl create namespace argocd || true
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@kubectl wait deployment/argocd-server -n argocd --for=condition=available

kind-down:
	@kind delete cluster --name ${CLUSTER_NAME}

kind-up:
	@kind create cluster --name ${CLUSTER_NAME} --config cluster.yaml

port-forward-argocd-ui:
	@printf "Use the following to login username: admin and password: "
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo && echo
	@kubectl port-forward svc/argocd-server -n argocd 8080:443
