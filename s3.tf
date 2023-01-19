

resource "aws_s3_bucket" "stanely-bucket" {
    bucket = "stanely07" 
    acl = "private" 
    tag = {
        name = "${var.app_name}-s3"
    }  
}


