This release is a major milestone in my journey towards supporting multi-arch builds.  

To simplify deployment and management, I've developed a Helm chart that streamlines the installation and configuration process on k8s clusters. The Helm chart includes all necessary configurations and dependencies to get you started quickly.  

In addition to the Helm chart, I've prepared a GitHub release containing the chart package, comprehensive release notes, and deployment instructions.  
[Release v1.0.1](https://github.com/andrefanatic/kbot/releases/tag/v1.0.1)

To begin, download the Helm chart package from the GitHub release page and use it to install the application on your k8s cluster.  

# Workflow illustration

# Instruction

```
kubectl config set-context --current --namespace=default
```

```
helm install kbot https://github.com/andrefanatic/kbot/releases/download/v1.0.1/kbot-0.1.0.tgz
```

```
kubectl get po                                                                                               
NAME                    READY   STATUS                       RESTARTS   AGE
kbot-7b5b97cc7d-6x598   0/1     CreateContainerConfigError   0          59s
```

```
kubectl describe po kbot-7b5b97cc7d-6x598 | grep Warning
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Warning  Failed     10s (x6 over 67s)  kubelet            Error: couldn't find key token in Secret default/kbot
```

```
kubectl create secret generic kbot --from-literal=token="YOUR_TELE_TOKEN"
```

```
kubectl get secret kbot -o jsonpath="{.data.token}" | base64 -d
```