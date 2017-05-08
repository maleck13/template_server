{
  "apiVersion": "apps/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "labels": {
      "run": "{{index . "app"}}",
      "name": "{{index . "app"}}"
    },
    "name": "{{index . "app"}}"
  },
  "spec": {
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "run": "{{index . "app"}}",
          "name":"{{index . "app"}}"
        }
      },
      "spec": {
        "containers": [
          {
            "image": "maleck13/"{{index . "app"}}":0.0.1",
            "imagePullPolicy": "Always",
            "name": "{{index . "app"}}",
            "resources": {},
            "terminationMessagePath": "/dev/termination-log"
          }
        ],
        "dnsPolicy": "ClusterFirst",
        "restartPolicy": "Always",
        "securityContext": {},
        "terminationGracePeriodSeconds": 30
      }
    }
  }
}