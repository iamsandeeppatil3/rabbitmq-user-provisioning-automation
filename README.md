# RabbitMQ User Provisioning Automation

Automation utilities for RabbitMQ user onboarding, permission assignment, credential generation, and credential distribution.

## Overview

This repository contains Bash-based automation developed to simplify RabbitMQ user management and reduce manual administrative effort during onboarding and migration activities.

The solution automates account creation, permission assignment, password generation, and credential distribution workflows.

## Components

### rabbitmq-user-provisioning.sh

Automates:

- RabbitMQ user creation
- Secure password generation
- User tagging
- Permission assignment
- Credential export

### rabbitmq-credential-distribution.sh

Automates:

- Reading exported credentials
- Generating onboarding emails
- Sending credentials to users

## Workflow

1. Define users
2. Generate passwords
3. Create RabbitMQ accounts
4. Assign permissions
5. Export credentials
6. Distribute credentials

## Technologies

- RabbitMQ
- Bash
- Linux
- SMTP

## Skills Demonstrated

- Messaging Infrastructure
- User Lifecycle Management
- Automation
- Linux Administration
- Bash Scripting

## Repository Structure

```text
rabbitmq-user-provisioning-automation/
├── rabbitmq-user-provisioning.sh
├── rabbitmq-credential-distribution.sh
├── examples/
└── docs/
