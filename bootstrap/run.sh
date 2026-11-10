#!/usr/bin/env bash
set -euo pipefail

root=$(dirname "$(dirname "$(realpath "$0")")")
: "${CLUSTER_NAME:?}" "${EXPECTED_ROLE_ARN:?}"
test "$CLUSTER_NAME" = rubyapi-prod
export AWS_DEFAULT_REGION=us-east-1
export AWS_REGION=us-east-1

# Use the machine role only; never substitute an SSO identity or open the API.
identity=$(aws sts get-caller-identity --output json)
IDENTITY="$identity" python3 - <<'PY'
import json, os
i = json.loads(os.environ['IDENTITY'])
assert i['Account'] == '794038216860'
assert i['Arn'].split('/')[1] == os.environ['EXPECTED_ROLE_ARN'].split('/')[-1]
assert ':assumed-role/' in i['Arn']
PY

curl --fail --silent --show-error --location https://dl.k8s.io/release/v1.37.0/bin/linux/amd64/kubectl -o /tmp/kubectl
echo '6129359f4e1f3848a5572ccb0b26cf28b8ca08cef38c95a765b2f64a2c961a2f  /tmp/kubectl' | sha256sum -c -
install -m 0755 /tmp/kubectl /usr/local/bin/kubectl
curl --fail --silent --show-error --location https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz -o /tmp/helm.tgz
echo 'a7f81ce08007091b86d8bd696eb4d86b8d0f2e1b9f6c714be62f82f96a594496  /tmp/helm.tgz' | sha256sum -c -
tar -xzf /tmp/helm.tgz -C /tmp linux-amd64/helm
install -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm
echo "1f2abd0368b5cd9562ea9316876a4e4dc2afcbcd3df2298fef6e0b9843100394  $root/bootstrap/vendor/argo-cd-10.17.1.tgz" | sha256sum -c -

export KUBECONFIG=/tmp/rubyapi-kubeconfig
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region us-east-1 --kubeconfig "$KUBECONFIG" >/dev/null
kubectl --request-timeout=30s get --raw=/readyz
kubectl apply --server-side --dry-run=server -f "$root/kubernetes/platform/capacity.yaml"
kubectl apply --server-side -f "$root/kubernetes/platform/capacity.yaml"
kubectl wait --for=condition=Ready nodeclass/rubyapi --timeout=180s
helm upgrade --install argocd "$root/bootstrap/vendor/argo-cd-10.17.1.tgz" \
  --namespace argocd --create-namespace \
  --values "$root/kubernetes/platform/argocd-values.yaml" \
  --wait --wait-for-jobs --timeout 15m

# No root Application, app pods, migrations, secret retrieval or traffic change.
kubectl wait --for=condition=Ready nodes -l karpenter.sh/nodepool=rubyapi --timeout=180s
kubectl get nodes -l karpenter.sh/nodepool=rubyapi -o wide
kubectl -n argocd get deployments,statefulsets,pods,services
test "$(kubectl -n argocd get svc argocd-server -o jsonpath='{.spec.type}')" = ClusterIP
test "$(kubectl -n argocd get cm argocd-cm -o jsonpath='{.data.admin\.enabled}')" = false
test "$(kubectl -n argocd get deploy argocd-applicationset-controller -o jsonpath='{.spec.replicas}')" = 0
test "$(kubectl -n argocd get applications -o jsonpath='{.items[*].metadata.name}')" = ''

# Retain non-secret runtime evidence in the build log, not just Helm's exit code.
kubectl get nodes -l karpenter.sh/nodepool=rubyapi -o json > /tmp/bootstrap-nodes.json
kubectl -n argocd get deployments,statefulsets,pods -o json > /tmp/bootstrap-argocd.json
python3 - <<'PY'
import json
from pathlib import Path
nodes = json.loads(Path('/tmp/bootstrap-nodes.json').read_text())['items']
assert 1 <= len(nodes) <= 2, 'Outside the approved two-instance envelope'
for node in nodes:
    labels = node['metadata']['labels']
    assert labels['kubernetes.io/arch'] == 'arm64'
    assert labels['node.kubernetes.io/instance-type'] == 'c9g.xlarge'
    assert labels['karpenter.sh/capacity-type'] == 'on-demand'
    assert any(c['type'] == 'Ready' and c['status'] == 'True' for c in node['status']['conditions'])
items = json.loads(Path('/tmp/bootstrap-argocd.json').read_text())['items']
for name in ('argocd-repo-server', 'argocd-server', 'argocd-redis', 'argocd-application-controller'):
    workload = next(x for x in items if x['kind'] in ('Deployment', 'StatefulSet') and x['metadata']['name'] == name)
    assert workload['spec']['replicas'] == workload['status']['readyReplicas'] == 1, name
pods = [x for x in items if x['kind'] == 'Pod' and x['status']['phase'] == 'Running']
assert len(pods) == 4
for pod in pods:
    assert all(c['ready'] for c in pod['status']['containerStatuses']), pod['metadata']['name']
print('BOOTSTRAP_RUNTIME_EVIDENCE=' + json.dumps({
    'nodes': [{'name': n['metadata']['name'], 'providerID': n['spec']['providerID'], 'architecture': n['status']['nodeInfo']['architecture'], 'capacity': n['status']['capacity']} for n in nodes],
    'pods': [{'name': p['metadata']['name'], 'node': p['spec']['nodeName'], 'containers': [{'name': c['name'], 'ready': c['ready'], 'imageID': c['imageID'], 'restarts': c['restartCount']} for c in p['status']['containerStatuses']]} for p in pods]
}, sort_keys=True))
PY
echo 'Bootstrap verified. Disable BootstrapAccess in CloudFormation now; production remains on EC2.'
