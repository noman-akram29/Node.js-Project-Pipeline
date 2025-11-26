# Node.js Project Pipeline

This repository contains a Node.js web application along with a complete **CI/CD pipeline** using **Jenkins**, **Docker**, and **Kubernetes**. The project also includes automated security scans, code quality checks, and production deployment.


---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Jenkins Pipeline](#jenkins-pipeline)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Security Scans](#security-scans)
- [License](#license)

---

## Project Overview

This is a **Node.js web application** designed for learning and demonstration purposes. It is fully integrated with a CI/CD pipeline that handles:

- Code checkout and workspace cleanup
- Dependency installation
- Static code analysis (SonarQube)
- Security scanning (Trivy, OWASP Dependency-Check)
- Docker image build and push
- Deployment to Docker host or Kubernetes cluster
- Zero-downtime deployment to Kubernetes
- Full RBAC setup for Jenkins in K8s

---

## Features

- Node.js application with REST API support
- Continuous Integration using **Jenkins**
- Continuous Delivery to **Docker** and **Kubernetes**
- Automated security scans:
  - File system vulnerability scan with **Trivy**
  - Image vulnerability scan with **Trivy**
  - Dependency security scan with **OWASP Dependency-Check**
- Code quality checks using **SonarQube**
- Kubernetes manifests included for deployment

---

## Prerequisites

- Jenkins server with the following tools configured:
  - JDK 17
  - Node.js 16
  - Docker
  - SonarQube Scanner
  - OWASP Dependency-Check
- Kubernetes cluster (Minikube, AWS EKS, GKE, or similar)
- Docker Hub account
- GitHub repository access

---

## Project Structure

Node.js-Project-Pipeline/
│
├─ k8s-deployment.yaml        # Kubernetes deployment and service manifests
├─ Jenkinsfile-CI                # Jenkins CD-pipeline definition
├─ Jenkinsfile-CD                # Jenkins CD-pipeline definition
├─ package.json               # Node.js dependencies
├─ server.js                  # Main application file
├─ .gitignore
├─ README.md
└─ other source files

