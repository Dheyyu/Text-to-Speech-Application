# Text-to-Speech Narrator with AWS and Terraform

This project implements a serverless Text-to-Speech Narrator using AWS Lambda, Amazon Polly, and Amazon S3.

The entire infrastructure is provisioned using Terraform, making it easy to deploy, test, and tear down your environment. This solution provides a great learning experience in building and managing serverless architectures with Terraform.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup and Deployment](#setup-and-deployment)
- [Testing the Application](#testing-the-application)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Notes and Future Enhancements](#notes-and-future-enhancements)
- [License](#license)

## Overview

The core functionality of this project is to convert any provided text into speech using Amazon Polly. The Lambda function accepts text (via a JSON payload), synthesizes speech, uploads the generated MP3 file to an S3 bucket (which is kept private), and returns a pre-signed URL for temporary access to the audio file.

_Note_: Amazon Polly has input size limits (around 3000 characters for plain text). In production or experiments with longer texts, you might need to split the text into smaller chunks.

## Architecture

PICTURE

## Project Structure

. ├── terraform/ │ ├── main.tf # Main Terraform configuration │ ├── variables.tf # Variable definitions │ └── outputs.tf # Output variables (e.g., API endpoints) ├── lambda/ │ ├── lambda_function.py # Lambda function code (text-to-speech conversion) │ └── lambda.zip # Deployment package (generated from lambda_function.py) └── README.md # This file

## Prerequisites

Before you begin, make sure you have the following installed and configured

- [Terraform](https://www.terraform.io/) (v0.12 or later recommended)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with appropriate credentials)
- Python 3.8+ (for developing the Lambda function)
- Basic knowledge of AWS services (Lambda, S3, IAM, and Amazon Polly)

## Setup and Deployment

### 1. Configure AWS Credentials

Ensure your AWS CLI is configured. For example, run:

```bash
aws configure
```

### 2 Provision Infrastructure with Terraform

Navigate to the terraform/ directory and run:

```bash
terraform init
```

To initialalize terraform on your local machine

Then run:

```bash
terraform validate
```

To validate your code is well structured

Then run:

```bash
terraform plan
```

To plan the way the resources would be created

Then finally, run:

```bash
terraform apply
```

To apply those changes and set up the resources.

Terraform will provision the following:

- An S3 bucket (for storing your synthesized audio)

- An IAM Role with permissions for Lambda, S3, and Polly

- A Lambda function that implements the text-to-speech conversion

Note: The S3 bucket ACL is set to private by default, and pre-signed URLs control temporary access.

### 3. Package and Deploy the Lambda Function

In the lambda/ directory, package your function code:

```bash
cd lambda
zip lambda.zip lambda_function.py
cd ..
```

Ensure your Terraform Lambda resource points to the correct ZIP file. Then, re-run terraform apply if necessary to update your Lambda deployment.

## Testing the Application

Since this project isn’t exposed via a public website, you can test the Lambda function below:

### A. Via the AWS Console

#### 1. Go to your Lambda function in the AWS Console.

#### 2. Click "Test" and set up a new test event with the following JSON payload:

```json
{
  "body": "{\"text\": \"Hello, this is a sample text-to-speech conversion.\"}"
}
```

#### 3. Invoke the test and inspect the response. A successful response returns a pre-signed URL for the audio file.

## Cleanup

When you're finished experimenting and documenting, tear down all the resources by running:

```bash
terraform destroy
```

This command removes all AWS resources that were created for this project.

Then you have successfully created the Text-to-Speech Application.
