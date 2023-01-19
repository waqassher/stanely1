

resource "aws_ecs_capacity_provider" "stanely-cp" {
  name = "capacity-provider-stanely"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.stanely-ASG.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}


resource "aws_ecs_cluster" "stanely-ecs-cluster" {
  name               = "stanely-ecs-cluster"
  capacity_providers = [aws_ecs_capacity_provider.stanely-cp.name]
  tags = {
    "env"       = "prod"
    "createdBy" = "Upgenics"
  }
}

## task definetion

resource "aws_ecs_task_definition" "stanely-task-definition" {
  family                = "web-family"
  container_definitions = file("container-defination/container-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "prod"
    "createdBy" = "upgenics"
  }
}

## Services

resource "aws_ecs_service" "stanely-service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.stanely-ecs-cluster.id
  task_definition = aws_ecs_task_definition.stanely-task-definition.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.stanely-tg.arn
    container_name   = "stanely-container"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.stanely-listener]
}
