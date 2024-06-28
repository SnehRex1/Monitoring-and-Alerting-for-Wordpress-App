# Monitoring-and-Alerting-for-Wordpress-App

## Objectives

1. **Deploy Prometheus / Grafana stack on Kubernetes using Helm charts.**
2. **Setup monitoring and alerting for the previously deployed WordPress application to track:**
   - Pod CPU utilization
   - Total request count for Nginx
   - Total 5xx requests for Nginx
3. **Create documentation for all required metrics for WordPress, Apache, and Nginx.**

## Prerequisites

- Kubernetes cluster (Minikube can be used for local development).
- Helm installed and configured.
- WordPress, MySQL, and Nginx application already deployed on Kubernetes (as per Part 1).

## Step-by-Step Guide

### Part-1 of project Deploying a production-grade WordPress application on Kubernetes

Copy this repo then Do all the step as mentioned in first part :- 
https://github.com/SnehRex1/Production-grade-Wordpress-app-deployment-on-Kubernetes-1/tree/master
then continue 

### 1. Deploy Prometheus and Grafana using Helm Charts

#### Add Helm Repositories

Add the Helm repositories for Prometheus and Grafana.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```
#### Create a Namespace for Monitoring
Create a separate namespace for monitoring components.

```
kubectl create namespace monitoring
```
#### Install Prometheus
Deploy Prometheus using the Helm chart.

```
helm install prometheus prometheus-community/prometheus -n monitoring
```
#### Install Grafana
Deploy Grafana using the Helm chart.

```
helm install grafana grafana/grafana -n monitoring
```
#### Install Grafana
Expose the Grafana service and retrieve the admin password.

```
kubectl get svc -n monitoring
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Forward the Grafana service port for local access.

```
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
Access Grafana by opening http://localhost:3000 in your web browser and log in with the username admin and the retrieved password.

### 2. Setup Prometheus Configuration

Create a ConfigMap for Prometheus to scrape metrics from the WordPress and Nginx services.


#### Create Prometheus ConfigMap

Create a file named prometheus-config.yaml

Apply the ConfigMap:

```
kubectl apply -f prometheus-config.yaml -n monitoring
```

### 3. Configure Grafana Dashboards 

#### Add Prometheus Data Source in Grafana

Open Grafana in your browser.
Navigate to Configuration > Data Sources.
Click Add data source and select Prometheus.
Set the URL to http://prometheus-server.monitoring.svc.cluster.local:80.
Click Save & Test to ensure Grafana can connect to Prometheus.

#### Import Dashboards

Grafana provides pre-built dashboards that can be used for monitoring.

Navigate to Create > Import.
Enter the dashboard ID for the desired dashboard.
Click Load, then select the Prometheus data source you added earlier, and click Import.

### 4. Create Alerting Rules and Alerts
Create an alerts.yaml file:

Create a file named alerts.yaml

Apply the alerting rules:

```
kubectl apply -f alerts.yaml -n monitoring
```

### 5. Document Metrics

#### Pod CPU Utilization

Metric Name: container_cpu_usage_seconds_total
Description: Total CPU time consumed by the container in seconds.
Query: rate(container_cpu_usage_seconds_total{namespace="default", pod="my-release-wordpress-chart"}[1m])

#### Total Request Count for Nginx

Metric Name: nginx_ingress_controller_requests
Description: Total number of HTTP requests handled by the Nginx ingress controller.
Query: sum(rate(nginx_ingress_controller_requests{namespace="default", service="nginx"}[1m]))

#### Total 5xx Requests for Nginx

Metric Name: nginx_ingress_controller_requests
Description: Total number of 5xx (server error) HTTP requests handled by the Nginx ingress controller.
Query: sum(rate(nginx_ingress_controller_requests{namespace="default", service="nginx", status=~"5.."}[1m]))

### 6. Verify Setup

Access Grafana: Ensure you can view the dashboards and the metrics are being populated.
Trigger Alerts: Test alerting by creating conditions that match your alert rules.
Document Setup: Ensure all steps are documented for future reference and troubleshooting.

### Conclusion
Fully functional monitoring and alerting setup for your WordPress application on Kubernetes using Prometheus and Grafana.




