resource "aws_ecs_cluster" "ecs_cluster" {

  name = "random-profile-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group_ecs.name
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "log_group_ecs" {
  name = "random-profile-service-lg"

  skip_destroy      = false
  retention_in_days = 7

}


resource "aws_ecs_service" "random_profile_api" {
  name            = "random-profile-api"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.random_profile_api.arn
  desired_count   = 1
  launch_type     =    "FARGATE"
  #   iam_role        = aws_iam_role.random_profile_api.arn
  #   depends_on      = [aws_iam_role_policy.random_profile_api]


  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "api"
    container_port   = 3000
  }

  network_configuration {
    subnets = [ aws_subnet.main.id ]
    security_groups = [ aws_security_group.security_group.id ]
    assign_public_ip = true
  }
}

# resource "aws_ecs_task_definition" "random_profile_api" {
#   family                = "random-person-temp"
#   container_definitions = file("task-def/task-def1.json")
#   cpu                   = 512
#   memory                = 1024
# }

resource "aws_ecs_task_definition" "random_profile_api" {
  family                   = "random-person-temp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = aws_iam_role.random_profile_api.arn
  execution_role_arn       = aws_iam_role.random_profile_api.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "api",
    "image": "dsylvester/random-person-temp:latest",
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "portMappings": [
        {                    
            "containerPort": 3000,
            "hostPort": 3000                    
        }
    ],  
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/ecs/random-person-temp",
            "mode": "non-blocking",
            "awslogs-create-group": "true",
            "max-buffer-size": "25m",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    }
    }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}