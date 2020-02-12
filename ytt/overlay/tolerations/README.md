# Overlay for Tolerations

```yaml
spec:
  template:
    spec:
      tolerations:
      - key: "dille.io/node-type"
        operator: "Equal"
        value: "loadbalancer"
        effect: "NoSchedule"
      - key: "dille.io/node-type"
        operator: "Equal"
        value: "loadbalancer"
        effect: "NoExecute"
```