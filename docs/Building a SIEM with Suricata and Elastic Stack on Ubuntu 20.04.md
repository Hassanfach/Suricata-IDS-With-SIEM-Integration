# Building a SIEM with Suricata and Elastic Stack on Ubuntu 20.04

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step 1 — Installing Elasticsearch and Kibana](#step-1--installing-elasticsearch-and-kibana)
- [Step 2 — Configuring Elasticsearch](#step-2--configuring-elasticsearch)
  - [Setting Up Elasticsearch Networking](#setting-up-elasticsearch-networking)
  - [Starting Elasticsearch](#starting-elasticsearch)
  - [Setting Up Elasticsearch Passwords](#setting-up-elasticsearch-passwords)
- [Step 3 — Configuring Kibana](#step-3--configuring-kibana)
  - [Enabling xpack Security in Kibana](#enabling-xpack-security-in-kibana)
  - [Setting Up Kibana Networking](#setting-up-kibana-networking)
  - [Setting Up Kibana Credentials](#setting-up-kibana-credentials)
  - [Starting Kibana](#starting-kibana)
- [Step 4 — Installing Filebeat](#step-4--installing-filebeat)
- [Step 5 — Exploring Kibana SIEM Dashboards](#step-5--exploring-kibana-siem-dashboards)
  - [Connecting to Kibana via SSH](#connecting-to-kibana-via-ssh)
  - [Navigating Kibana SIEM Dashboards](#navigating-kibana-siem-dashboards)
- [Conclusion](#conclusion)

## Introduction
This guide walks you through setting up a Security Information and Event Management (SIEM) system using Suricata as an Intrusion Detection System (IDS) integrated with the Elastic Stack (Elasticsearch, Kibana, and Filebeat) on Ubuntu 20.04. A SIEM system helps you collect, store, and analyze security data to identify threats and suspicious activities on your network or servers.

The components in this SIEM setup are:
- **Elasticsearch**: Stores, indexes, and searches security events from Suricata.
- **Kibana**: Offers a visual interface to explore and analyze security logs.
- **Filebeat**: Parses Suricata’s `eve.json` log file and sends events to Elasticsearch.
- **Suricata**: Scans network traffic for suspicious activities, logging or blocking malicious packets.

This tutorial will show you how to install and configure Elasticsearch, Kibana, and Filebeat to create a working SIEM. You’ll also learn how to access Kibana’s dashboards via an SSH tunnel to monitor Suricata’s events and alerts.

## Prerequisites
Before starting, ensure you have:
- **Suricata Server**: An Ubuntu 20.04 server with Suricata installed and configured. If not set up, refer to [How to Install Suricata on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-suricata-on-ubuntu-20-04). Make sure Suricata rules are configured to generate alerts (see [Understanding Suricata Signatures](https://www.digitalocean.com/community/tutorials/understanding-suricata-signatures)).
- **Elasticsearch Server**: A second Ubuntu 20.04 server with:
  - 4GB RAM and 2 CPUs.
  - A non-root user with sudo privileges (see [Initial Server Setup with Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)).
  - Private network connectivity between servers (e.g., via a VPN like WireGuard or a cloud provider’s private networking). Alternatively, run all components on a single server for testing.
- **Network Setup**: Both servers must communicate using private IP addresses.
- **Firewall**: Configured to allow required traffic (instructions provided in later steps).

## Step 1 — Installing Elasticsearch and Kibana
Begin by installing Elasticsearch and Kibana on your Elasticsearch server to manage and visualize Suricata logs.

1. Add the Elastic GPG key:
   ```bash
   curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
