{
    "kind": "Template",
    "apiVersion": "v1",
    "metadata": {
        "name": "{{index . "app"}}"
    },
    "objects": [
        {
            "kind": "Route",
            "apiVersion": "v1",
            "metadata": {
                "name": "{{index . "app"}}",
                "labels": {
                    "app": "{{index . "app"}}"
                }
            },
            "spec": {
                "host": "",
                "to": {
                    "kind": "Service",
                    "name": "{{index . "app"}}",
                    "weight": 100
                },
                "port": {
                    "targetPort": 3000
                }
            }
        },
        {
            "kind": "Service",
            "apiVersion": "v1",
            "metadata": {
                "name": "{{index . "app"}}",
                "labels": {
                    "app": "{{index . "app"}}"
                }
            },
            "spec": {
                "ports": [
                    {
                        "protocol": "TCP",
                        "port": 3000,
                        "targetPort": 3000
                    }
                ],
                "selector": {
                    "app": "{{index . "app"}}",
                    "deploymentconfig": "{{index . "app"}}"
                },
                "type": "ClusterIP",
                "sessionAffinity": "None"
            }
        },
        {
            "kind": "DeploymentConfig",
            "apiVersion": "v1",
            "metadata": {
                "name": "{{index . "app"}}",
                "generation": 4,
                "labels": {
                    "app": "{{index . "app"}}"
                }
            },
            "spec": {
                "strategy": {
                    "type": "Rolling",
                    "rollingParams": {
                        "updatePeriodSeconds": 1,
                        "intervalSeconds": 1,
                        "timeoutSeconds": 600,
                        "maxUnavailable": "25%",
                        "maxSurge": "25%"
                    },
                    "resources": {}
                },
                "triggers": [
                    {
                        "type": "ConfigChange"
                    }
                ],
                "replicas": 1,
                "selector": {
                    "app": "{{index . "app"}}",
                    "deploymentconfig": "{{index . "app"}}"
                },
                "template": {
                    "metadata": {
                        "labels": {
                            "app": "{{index . "app"}}",
                            "deploymentconfig": "{{index . "app"}}"
                        },
                        "annotations": {
                            "openshift.io/container.cleanapp.image.entrypoint": "[\"/usr/src/server\"]"
                        }
                    },
                    "spec": {
                        "containers": [
                            {
                                "name": "{{index . "app"}}",
                                "image": "maleck13/{{index . "app"}}:latest",
                                "resources": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "imagePullPolicy": "Always"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "securityContext": {}
                    }
                }
            },
            "status": {
                "observedGeneration": 4,
                "replicas": 1,
                "updatedReplicas": 1,
                "availableReplicas": 1
            }
        }
    ]
}