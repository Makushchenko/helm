# helm

Different DevOps projects with adoption of Helm

These commands are used in CI/local workflows to preview and render Kubernetes manifests with Helm, test upgrades safely, and control specific templates via `--show-only` (`-s`) while overriding chart values inline.

---

## Commands

### 1) Validate an upgrade (no changes applied)

```bash
helm upgrade current-version ./helm \
  --set image.tag=v5.0.0 \
  --dry-run --debug
```

**Description:** Simulates upgrading the `current-version` release from `./helm` with `image.tag=v5.0.0`, printing rendered manifests and debug logs without touching the cluster.

---

### 2) Render selected templates with value overrides

```bash
helm template demo ./helm \
  -s templates/api-deploy.yaml \
  --set image.tag=v5.0.0 \
  -s templates/api-svc.yaml \
  --set api.canary=5 \
  --set api.header=randomsequense \
  -s templates/app-configmap.yaml \
  --set app.version=v5
```

**Description:** Locally renders **only** the specified templates (deploy, service, configmap) using the provided value overrides and outputs YAML to stdout (no deployment).

---

### 3) Render selected templates including Secret

```bash
helm template demo ./helm \
  -s templates/api-deploy.yaml \
  -s templates/api-svc.yaml \
  -s templates/app-configmap.yaml \
  -s templates/secret.yaml \
  --set image.tag=v5.0.0 \
  --set api.canary=5 \
  --set api.header=randomsequense
```

**Description:** Same as above, but also renders the Secret template. Useful for full manifest review; avoid real secrets in logs/artifacts.

---

**Note:** `helm template` only renders; to deploy use:

```bash
helm upgrade --install <release> ./helm --set image.tag=... -n <namespace> --wait --atomic
```
**Flags:**

* `--wait` — waits until all Pods, PVCs, Services, and the minimum Pods of Deployments/StatefulSets/ReplicaSets are **Ready** before marking the release successful (up to `--timeout`, default 5m). ([Helm](https://helm.sh/docs/helm/helm_install/))
* `--atomic` — makes the operation transactional:

  * **install:** delete the release on failure;
  * **upgrade:** roll back to the previous revision on failure;
  * also **implies `--wait`**. ([Helm](https://helm.sh/docs/helm/helm_install/))

---

### 4) Inspect the live manifest of an installed release

```bash
helm get manifest current-version
```

**Description:** Prints the **generated YAML manifest** for the `current-version` release (all Kubernetes resources rendered by the chart and its dependencies). Useful for troubleshooting, diffs, and verifying what’s actually applied in the cluster. ([helm.sh](https://helm.sh/docs/helm/helm_get_manifest/?utm_source=chatgpt.com))

---

### 5) Roll back a release to a specific revision
```bash
helm rollback current-version 1
```
**Description:** Reverts the `current-version` release to **revision 1**. Use `helm history current-version` to see available revisions; if the revision is omitted or set to `0`, Helm rolls back to the **previous** release. You can add `--wait` (and set `--timeout`) to wait for resources to become Ready. ([helm.sh](https://helm.sh/docs/helm/helm_rollback/))

---