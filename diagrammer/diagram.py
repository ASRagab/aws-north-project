from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2, Lambda
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB, VPC, APIGateway, InternetGateway
from diagrams.aws.analytics import ManagedStreamingForKafka as MSK
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3


with Diagram("Missouri Commerce AWS Architecture", outformat="png"):
    vpc = VPC("VPC")

    ig = InternetGateway("Internet Gateway")
    alb = ELB("Application Load Balancer")
    
    with Cluster("Public Subnet"):
        web = EC2("Web Server")
    
    with Cluster("Private Subnet"):
        db = RDS("Database")
    
    api = APIGateway("API Gateway")

    lambda_function = Lambda("Event Publisher")
    msk = MSK("Service Bus")

    api << lambda_function << msk

    api >> alb >> web
    web >> db
    
    ig >> vpc
