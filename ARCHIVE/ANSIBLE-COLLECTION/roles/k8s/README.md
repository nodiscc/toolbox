# toolbox.k8s

This role will install [https://en.wikipedia.org/wiki/Kubernetes](https://example.org/), an open-source container orchestration system for automating software deployment, scaling, and management.

It will configure the host as a kubernetes control plane node (master) or as a worker node that will join the cluster managed by the control plane node.

![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/84px-Kubernetes_logo_without_workmark.svg.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: k8s
  roles:
    - nodiscc.xsrv.common # (optional) base Debian server setup
    - nodiscc.xsrv.monitoring # (optional) performance/health monitoring
    - nodiscc.toolbox.k8s

# required variables
# host_vars/k8s-master.CHANGEME.org/k8s-master.CHANGEME.org.yml
k8s_node_role: master

# host_vars/k8s-worker*.CHANGEME.org/k8s-worker*.CHANGEME.org.yml
k8s_node_role: worker
k8s_master_node: k8s-master.CHANGEME.org
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

On the master (_control plane_) node, `kubectl` commands expect the `KUBECONFIG` environment variable to contain the path to the k8s configuration file. Example: `sudo KUBECONFIG=/etc/kubernetes/admin.conf kubeadm token create`


### Backups

TODO

## Tags

<!--BEGIN TAGS LIST-->
```
k8s - setup k8s container orchestrator
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=k8s

