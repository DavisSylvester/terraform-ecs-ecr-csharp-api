resource "aws_iam_role" "random_profile_api" {
    name = "random-profile-api-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })    

    inline_policy {
        name = "random-profile-api-policy"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action   = [
                        "ecs:*",
                        "logs:*"
                        ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
  tags = {
    tag-key = "tag-value"
  }
}

# resource "aws_iam_policy" "policy_two" {
#   name = "policy-381966"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:*"]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }