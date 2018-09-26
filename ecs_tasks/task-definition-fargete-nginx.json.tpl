[
  {
      "name": "${name}",
      "image": "${image}:${version}",
      "memory": ${memory},
      "cpu": ${cpu},
      "essential": true,
      "network_mode": "awsvpc"
      "portMappings": [
          {
              "containerPort": ${docker_port},
              "hostPort": 0,
              "protocol": "tcp"
          }
      ],
      "ulimits": [
          {
            "name": "nofile",
            "softLimit": 8192,
            "hardLimit": 1048576
          }
      ],
      "environment": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${awslogs-group}",
          "awslogs-region": "${awslogs-region}",
          "awslogs-stream-prefix": "${version}"
        }
      }
  }
]
