{
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
            "creationTimestamp": null,
            "generation": 1,
            "labels": {
                "run": "{{index . "app"}}"
            },
            "name": "{{index . "app"}}"
        },
        "spec": {
            "ports": [{
                "name":"api",
                "port": 3000,
                "targetPort": 8080
            },{
                "name":"web",
                "port": 8100,
                "targetPort": 8100
            }],
            "selector": {
                "name": "{{index . "app"}}"
            }
        }
    }