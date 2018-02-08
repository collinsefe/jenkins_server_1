{
    "name": "${var.ecs_task_family}",
    "image": "${var.ecs_task_image}",
    "mountPoints": [
      {
        "sourceVolume": "${var.ecs_task_volume_name}",
        "containerPath": "${var.ecs_task_container_path}"
      },
      {
      "essential": true,
      "cpu": 1024,
      "memory": 992
      }
    ],
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080,
        "protocol": "tcp"
      },
      {
        "hostPort": 50000,
        "containerPort": 50000,
        "protocol": "tcp"
      }
    ]
  }

