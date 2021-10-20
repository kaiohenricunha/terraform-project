# 1 - AWS Regions and AZs

- AWS Regions are separate geographic areas that AWS uses to house its infrastructure. These are distributed around the world so that customers can choose a region closest to them in order to host their cloud infrastructure there. The closer your region is to you, the better, so that you can reduce network latency as much as possible for your end-users. You want to be near the data centers for fast service.

- Not all regions are created equally. These regions have more services than others in their general areas:
    - Americas: US East (N. Virginia), US West (N. California)
    - Asia Pacific:  Singapore, Sydney, Tokyo
    - EU: Frankfurt, Ireland

- AZs are basically isolated locations— data centers — within a region. Important for resiliency.

- If you distribute your instances across multiple Availability Zones and one instance fails, you can design your application so that an instance in another Availability Zone can handle requests. This is like an emergency load balancer without using an actual load balancer.

# 2 - EC2

- AMI: an image for the creation of virtual servers -- known as EC2 instances -- in the Amazon Web Services (AWS) environment. The machine images are like templates that are configured with an operating system and other software that determine the user's operating environment.

- Security Groups: By default,AWS does not allow any incoming or outgoing traffic from an EC2 Instance. Show my port 80 Ingress and the Egress.

    - This code creates a new resource called aws_security_group and specifies that this group allows incoming TCP requests from port 80 on port 80 from those CIDR blocks, which are subnet ranges tha can access the Ingress. The one in the middle is HP's VPN, the others, VPC's. The Egress specifies that the Instances can send traffic from any port to any port, in any possible protocol, to any IP range. Pretty much all internet.

- Elastic IPs: By using an Elastic IP address, you can mask the failure of an instance or software by rapidly remapping the address to another instance in your account. Alternatively, you can specify the Elastic IP address in a DNS record for your domain, so that your domain points to your instance. An Elastic IP address is a public IPv4 address, which is reachable from the internet. If your instance does not have a public IPv4 address, you can associate an Elastic IP address with your instance to enable communication with the internet.

- Load Balancers: distributes traffic across servers and give all your users the IP (actually, the DNS name) of the load balancer, instead of the instances' IPs.

    - Listener: This listener configures the ALB     to listen on the default HTTP port, port
    80, use HTTP as the protocol, and send a simple 404 page as the default
    response for requests that don’t match any listener rules.

    - Target Group: sends an HTTP request to each instance periodically to check their health

    - LB Listener Rule: sends requests that match any
    path to the target group that contains your ASG.

- ASG:  An ASG takes care of a lot of tasks for you completely automatically, including launching a cluster of EC2 Instances, monitoring the health of each Instance, replacing failed Instances, and
adjusting the size of the cluster in response to load.

- EBS disk: After you attach a volume to an instance, you can use it as you would use a physical hard drive.

- Terraform: Software tool that allows DevOps engineers to programmatically provision the physical resources an application requires to run. Infrastructure as code is an IT practice that manages an application's underlying IT infrastructure through programming.

- Show kaioc-terraform-tg