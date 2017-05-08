{
  "apiVersion": "extensions/v1beta1",
  "kind": "Ingress",
  "metadata": {
    "name": "{{index . "app"}}-web-ingress",
    "annotations": {
      "kubernetes.io/ingress.class": "nginx"
   //   "kubernetes.io/tls-acme": "true"
    }
  },
  "spec": {
    // "tls": [
    //   {
    //     "hosts": [
    //       "storypoint.me",
    //       "api.storypoint.me"
    //     ],
    //     "secretName": "storypoints-tls"
    //   }
    // ],
    "rules": [
      {
        "host": "",
        "http": {
          "paths": [
            {
              "path": "/",
              "backend": {
                "serviceName": "{{index . "app"}}",
                "servicePort": "web"
              }
            }
          ]
        }
      }
    ]
  }
}