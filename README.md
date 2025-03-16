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
