# ktsg-argocd-demo

Simplistic [GitOps](https://www.weave.works/technologies/gitops/) demo

Will use
- Local [kind cluster](https://kind.sigs.k8s.io/)
- [Helm chart](https://helm.sh/) to manage and configure a service deployment
- A very simple [web app](./app)
- [ArgoCD](https://argoproj.github.io/argo-cd/) to manage the service deployments

To keep this simple we will NOT cover
- Ingress options
- Bootstraping k8s addons etc. with ArgoCD
- ArgoCD configuration options for external access, SSO, team privileges etc.



## Branches
| Branch   | Purpose                         |
| ---------| --------------------------------|
| main     | App source code and Helm chart  |
| gh-pages | Helm chart repository           |




## CI
Uses [GitHub actions](https://docs.github.com/en/actions)
- Will use the GitHub container registry, so will need to [enable the GitHub container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/enabling-improved-container-support-with-the-container-registry)
	- Will also need to make the package public when doing so, see [here](https://docs.github.com/en/packages/learn-github-packages/configuring-a-packages-access-control-and-visibility)
- Will use a [gh-pages branch](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site) for the Helm chart repository

There are 2 workflows

**On merge requests for the main branch and commits to the main branch**
- See [build workflow](./github/workflows/build.yaml)
- Check Helm chart
- Build and test image

**On tagging**
- See [release workflow](./github/workflows/release.yaml)
- Build and publish image
- Publish a Helm chart version


### Artificats
OCI image
```
docker image pull ghcr.io/pmcgrath/ktsg-argocd-demo:v0.1.0
```

Helm chart repository - note the Url is different as I have other gh-pages repos
```
helm repo add ktsg-argocd-demo https://pmcgrath.net/ktsg-argocd-demo/
```



## CD
PENDING



## Run book
Get ArgoCD up and running
```
# Start k8s
make kind-up

# Install ArgoCD - no ingress
make install-argocd

# Open ArgoCD UI via port forwarding - Can see at localhost:8080
make port-forward-argocd-ui
```



## References
- [GitHub pages creation for existing repo](https://gist.github.com/ramnathv/2227408#gistcomment-2915143)
- [GitHub commit statuses](https://docs.github.com/en/rest/reference/repos#statuses)
- [GitOps conf 2021](https://www.youtube.com/watch?v=KbFLAl7zZKo&list=PLXOML2VBdIo7xEp8Bo9kFB-d6tTlHK5Fk)
- [GitOps Guide to the Galaxy](https://www.youtube.com/playlist?list=PLaR6Rq6Z4IqfGCkI28cUMbNhPhsnj4nq3) - Lots of ArgoCD content
- [FluxCD](https://fluxcd.io/docs/) - Alternative to ArgoCD
- [Tekton](https://tekton.dev/) - Alternative low level building blocks for GitOps workflows on k8s
- [podinfo](https://github.com/stefanprodan/podinfo) - Good reference re Helm content and GitHub actions
