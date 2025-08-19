alias h=heml
alias h=helm

# --- argocd chart --------
helm repo add argo https://argoproj.github.io/argo-helm
helm ls
helm repo update argo
helm lint argo
helm install my-argo-cd argo/argo-cd --version 8.3.0
kubectl port-forward service/my-argo-cd-argocd-server -n default 8080:443&
helm search repo argo
h ls
h status my-argo-cd
helm install my-argo-cd argo/argo-cd --version 8.3.0
helm show values argo/argo-cd
helm get values my-argo-cd
helm upgrade my-argo-cd argo/argo-cd --version 8.3.0
h ls --all
helm rollback my-argo-cd 1
helm status my-argo-cd
# --- demo-chart --------
h create demo-chart
h lint
helm package demo-chart
helm package demo-chart
helm install demo-chart ./demo-chart-0.1.0.tgz
h ls
h status demo-chart
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=demo-chart,app.kubernetes.io/instance=demo-chart" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
h ls
h upgrade demo-chart demo-chart-0.1.0.tgz --set replicaCount=2
k get pods
h ls
h rollback demo-chart 1
h ls
k get pods
h uninstall demo-chart
h plugin list
helm get manifest current-version