# Oxer Fitness Website - AWS EC2 Terraform & Jenkins CI/CD Deployment

This repository contains the **Oxer Fitness** static HTML website along with infrastructure-as-code (**Terraform**) and a **Jenkins CI/CD Pipeline** (`Jenkinsfile`) for automated deployment to an AWS EC2 instance.

---

## 📁 Repository Structure

```text
oxer-html/
├── css/                        # Website CSS stylesheets
├── images/                     # Website images & assets
├── js/                         # JavaScript files
├── index.html                  # Main landing page
├── about.html                  # About page
├── blog.html                   # Blog page
├── class.html                  # Classes page
├── Jenkinsfile                 # Jenkins Declarative Pipeline script
├── terraform/                  # Terraform Infrastructure as Code
│   ├── provider.tf             # AWS provider configuration
│   ├── variables.tf            # Input variables
│   ├── main.tf                 # EC2, Security Group & User Data setup
│   ├── outputs.tf              # Outputs (Public IP, DNS, URL)
│   └── terraform.tfvars.example # Example variable values
└── README.md                   # Project documentation
```

---

## 🚀 Infrastructure Details (Terraform)

The `terraform/` directory provisions the required AWS resources:

- **Security Group**: Permits inbound HTTP (`80`) and SSH (`22`) traffic, and all outbound traffic.
- **EC2 Instance**: Launches an Amazon Linux 2023 instance (`t2.micro` by default).
- **User Data**: Automatically updates packages, installs Apache (`httpd`), enables the service, and sets up the web server.

### Provisioning Locally

1. **Navigate to the Terraform directory:**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Validate configuration:**
   ```bash
   terraform validate
   ```

4. **Review execution plan:**
   ```bash
   terraform plan
   ```

5. **Apply configuration:**
   ```bash
   terraform apply -auto-approve
   ```

6. **Clean up resources:**
   ```bash
   terraform destroy -auto-approve
   ```

---

## ⚙️ Jenkins CI/CD Pipeline Integration

The `Jenkinsfile` provides an automated build and deployment pipeline with manual parameter controls.

### Pipeline Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `ACTION` | Choice | `plan` | Action to execute: `plan`, `apply`, or `destroy` |
| `AWS_REGION` | String | `us-east-1` | AWS target region for deployment |

### Pipeline Stages

1. **Checkout Code**: Clones the latest code from Git.
2. **Terraform Init**: Initializes the Terraform workspace and provider plugins.
3. **Terraform Validate**: Checks code formatting and structural correctness.
4. **Terraform Plan**: Generates an execution plan (`tfplan`).
5. **Terraform Apply**: Runs `terraform apply` (executed when `ACTION` is `apply`).
6. **Terraform Destroy**: Runs `terraform destroy` (executed when `ACTION` is `destroy`).

---

## 🛠️ Prerequisites & Setup in Jenkins

1. **AWS Credentials in Jenkins**:
   - Navigate to **Manage Jenkins > Credentials > System > Global credentials**.
   - Add new credentials with ID: `aws-credentials` (AWS Access Key ID & Secret Access Key).

2. **Terraform Installed on Jenkins Agent**:
   - Ensure `terraform` CLI is installed and available in `PATH` on the Jenkins node/agent executing the build.

3. **Create Jenkins Pipeline Job**:
   - Create a new **Pipeline** item in Jenkins.
   - Under **Pipeline**, set Definition to **Pipeline script from SCM**.
   - Select **Git**, set the Repository URL, and specify `Jenkinsfile` as the Script Path.
   - Run **Build with Parameters** to initiate deployment.
# AWS EC2 Terraform + Jenkins CI/CD Architecture

```text
                         +----------------------+
                         |      Developer       |
                         +----------+-----------+
                                    |
                                    | Push Code
                                    v
                      +-------------------------------+
                      |      GitHub Repository        |
                      | HTML | CSS | JS | Terraform   |
                      +---------------+---------------+
                                      |
                                      | Git Clone
                                      v
                          +--------------------------+
                          |      Jenkins Server      |
                          |    Pipeline Job (CI/CD)  |
                          +------------+-------------+
                                       |
                                       |
             ---------------------------------------------------------
             |                     |                |                |
             v                     v                v                v
     Checkout Code        Terraform Init   Terraform Validate  Terraform Plan
                                                                     |
                                                                     |
                                                             Build with Parameters
                                                                     |
                                             -----------------------------------------
                                             |                    |                  |
                                             |                    |                  |
                                             v                    v                  v
                                        ACTION=plan        ACTION=apply      ACTION=destroy
                                                                  |                  |
                                                                  |                  |
                                                                  v                  v
                                                         Terraform Apply     Terraform Destroy
                                                                  |
                                                                  |
                                                                  v
                           +--------------------------------------------------+
                           |                    AWS Cloud                     |
                           +--------------------------------------------------+
                                          |
                       -----------------------------------------
                       |                                       |
                       v                                       v
              Security Group                         Amazon Linux EC2
              Port 22 (SSH)                          Apache Installed
              Port 80 (HTTP)                         Git Installed
                                                     Website Deployed
                                                            |
                                                            |
                                                            v
                                                Static Website Running
                                                            |
                                                            v
                                           http://<EC2-Public-IP>
```

---

# Deployment Workflow

```text
Developer
    │
    ▼
Push Code to GitHub
    │
    ▼
Jenkins Pipeline Trigger
    │
    ▼
Checkout Repository
    │
    ▼
Terraform Init
    │
    ▼
Terraform Validate
    │
    ▼
Terraform Plan
    │
    ▼
Terraform Apply
    │
    ▼
AWS Creates:
    ├── Security Group
    ├── EC2 Instance
    └── User Data Execution
             │
             ▼
Install Apache
Install Git
Clone Website
Copy HTML/CSS/JS
Start Apache
             │
             ▼
Website Live
```

---

# Terraform Resource Flow

```text
Terraform
     │
     ▼
Fetch Latest Amazon Linux AMI
     │
     ▼
Create Security Group
     │
     ▼
Launch EC2 Instance
     │
     ▼
Run User Data
     │
     ├── Update Packages
     ├── Install Apache
     ├── Install Git
     ├── Clone GitHub Repository
     ├── Copy Website Files
     └── Start Apache
     │
     ▼
Website Available
```

---

# AWS Resources Created

```text
AWS
│
├── EC2 Instance
│      ├── Amazon Linux 2023
│      ├── Apache Web Server
│      ├── Git Installed
│      └── Static Website
│
├── Security Group
│      ├── Port 22 (SSH)
│      └── Port 80 (HTTP)
│
└── Key Pair
       └── SSH Access
```
