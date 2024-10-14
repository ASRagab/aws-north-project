from diagrams import Diagram, Cluster
from diagrams.aws.compute import ECS, Lambda, AutoScaling
from diagrams.aws.database import Aurora
from diagrams.aws.network import ALB, VPC, APIGateway, InternetGateway
from diagrams.aws.security import Cognito
from diagrams.aws.analytics import ManagedStreamingForKafka as MSK
from diagrams.aws.analytics import KinesisDataStreams
from diagrams.aws.storage import S3

def create_aws_diagram():
    with Diagram("Missouri Commerce AWS Architecture", show=False, filename="architecture"):
        with Cluster("US-East-2"):
            cognito = Cognito("Cognito User Pool")
            s3 = S3("MSK Events and Error Logs")
            igw = InternetGateway("Internet Gateway")
            api = APIGateway("Missouri API Gateway")
            firehose = KinesisDataStreams("Data Delivery Stream")
            with Cluster("VPC"):
              vpc = VPC("VPC")

              with Cluster("Private Subnets"):
                  db = Aurora("Aurora Serverless v2")
                  msk = MSK("MSK Cluster")
                  lambdas = [
                      Lambda("Orders Notification Service"),
                      Lambda("Shipping Notification Service")
                  ]
                  with Cluster("Autoscaling Groups"):
                    autoscaling_group = AutoScaling("Service Autoscaling Group")
                    fargate = [
                        ECS("User Service"),
                        ECS("Inventory Service"),
                        ECS("Payments Service"),
                        ECS("Orders Service"),
                      ]

              with Cluster("Public Subnets"):
                  alb = ALB("Application Load Balancer")




            # Connections
        igw >> vpc
        api >> lambdas >> msk
        msk >> firehose >> s3
        autoscaling_group >> fargate
        alb >> fargate
        fargate >> db
        msk - fargate
        cognito >> api

if __name__ == "__main__":
    create_aws_diagram()
