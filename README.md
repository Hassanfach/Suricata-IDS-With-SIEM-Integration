# Build and Configure IDS Using Suricata and Integrated with Filebeat-Elastic-Kibana for SIEM

This repository provides a comprehensive guide and configuration files
to build a Security Information and Event Management (SIEM) system using
Suricata as an Intrusion Detection System (IDS) integrated with the
Elastic Stack (Elasticsearch, Kibana, and Filebeat) on Ubuntu 20.04. The
setup enables you to monitor network traffic, detect suspicious
activities, and visualize security events through Kibana dashboards.

## Overview

This project guides you through: - Installing and configuring Suricata
as an IDS to scan network traffic for suspicious events. - Setting up
Elasticsearch to store and index security events. - Configuring Kibana
to visualize and navigate event logs. - Using Filebeat to parse
Suricata's `eve.json` logs and send them to Elasticsearch. - Connecting
to Kibana via an SSH tunnel to explore SIEM dashboards.

The complete step-by-step guide is available in the `docs/` directory,
with configuration files in `config/` and automation scripts in
`scripts26/` to streamline the setup process.

## Prerequisites

To follow this guide, you need: - **Two Ubuntu 20.04 servers**: -
**Suricata Server**: For running Suricata with configured rules to
generate alerts. - **Elasticsearch Server**: For hosting Elasticsearch
and Kibana, with 4GB RAM, 2 CPUs, and a non-root sudo user. - **Private
network connectivity** between the servers (e.g., via a VPN like
WireGuard or a cloud provider's private networking). Alternatively, run
all components on a single server for testing. - **Suricata
signatures**: Configured rules to generate alerts (see `docs/` for
guidance on setting up Suricata rules). - **Firewall**: Configured to
allow necessary traffic (instructions provided in the guide).

## Getting Started

1.  **Read the Documentation**: Follow the detailed guide in
    `docs/How-To-Build-A-SIEM-with-Suricata-and-Elastic-Stack-on-Ubuntu-20.04.md`
    for step-by-step instructions.
2.  **Apply Configuration Files**: Use the provided `elasticsearch.yml`,
    `kibana.yml`, and `filebeat.yml` files in `config/` to configure
    your services. Replace placeholders (e.g., `your_private_ip`) with
    your server's private IP address and credentials.
3.  **Run Automation Scripts**: Use scripts in `scripts/` to automate
    installation and configuration:
    -   `install_elasticsearch_kibana.sh`: Installs Elasticsearch and
        Kibana.
    -   `configure_elasticsearch.sh`: Configures Elasticsearch
        networking and security.
    -   `configure_kibana.sh`: Configures Kibana networking and
        credentials.
    -   `install_filebeat.sh`: Installs and configures Filebeat on the
        Suricata server.
    -   `install_ids.sh` : Installs and configures Suricata as IDS
4.  **Access Kibana**: Use an SSH tunnel to connect to Kibana and
    explore the SIEM dashboards.

## Repository Structure

-   **`docs/`**: Contains the full guide
    (`How-To-Build-A-SIEM-with-Suricata-and-Elastic-Stack-on-Ubuntu-20.04.md`).
-   **`config/`**: Stores configuration files:
    -   `elasticsearch.yml`: Elasticsearch settings for networking and
        security.
    -   `kibana.yml`: Kibana settings for networking and encryption
        keys.
    -   `filebeat.yml`: Filebeat settings for parsing Suricata logs and
        sending to Elasticsearch.
    -   `suricata.yaml`: Suricata settings
    -   `custom.rules`: Rules to detect common threat
-   **`scripts/`**: Automation scripts for installation and
    configuration:
    -   `install_elasticsearch_kibana.sh`
    -   `configure_elasticsearch.sh`
    -   `configure_kibana.sh`
    -   `install_filebeat.sh`
    -   `install_ids.sh`
-   **`.gitignore`**: Specifies files to exclude from version control.

## Usage

1.  Clone this repository:

    ``` bash
    git clone https://github.com/Hassanfach/Suricata-IDS-With-SIEM-Integration/tree/main
    ```

2.  Follow the guide in `docs/` to set up Suricata, Elasticsearch,
    Kibana, and Filebeat.

3.  Copy configuration files from `config/` to the appropriate servers:

    -   `elasticsearch.yml` and `kibana.yml` to the Elasticsearch
        server.
    -   `filebeat.yml` to the Suricata server.

4.  Run the scripts in `scripts/` to automate setup. Example:

    ``` bash
    bash scripts/install_elasticsearch_kibana.sh
    bash scripts/configure_elasticsearch.sh <private_ip> <interface>
    bash scripts/configure_kibana.sh <private_ip> <kibana_system_password>
    bash scripts/install_filebeat.sh <private_ip> <elastic_password>
    bash scripts/install_ids.sh
    ```

    Replace `<private_ip>`, `<interface>`, `<kibana_system_password>`,
    and `<elastic_password>` with your server's private IP, network
    interface, and passwords generated during setup.

5.  Access Kibana via an SSH tunnel:

    ``` bash
    ssh -L 5601:<private_ip>:5601 <user>@<public_ip> -N
    ```

    Open `http://127.0.0.1:5601` in your browser and log in with the
    `elastic` user credentials.

## Notes

-   **Security**: Replace placeholders in configuration files (e.g.,
    `your_private_ip`, passwords) with actual values. Store credentials
    securely and avoid hardcoding them in the repository.
-   **Customization**: Adjust Suricata rules in `/etc/suricata/rules/`
    to match your network's threat model.
-   **Troubleshooting**: Check service status with
    `sudo systemctl status <service>.service` (e.g., `elasticsearch`,
    `kibana`, `filebeat`) and review logs in `/var/log/` if issues
    arise.
-   **Further Enhancements**: Add more Filebeat modules, configure
    advanced Suricata rules, or set up Nginx as a reverse proxy for
    external Kibana access (see documentation for details).

## Contributing

Contributions are welcome! Please read `CONTRIBUTING.md` (if added) for
guidelines on submitting issues or pull requests.

## Acknowledgments

-   Based on the tutorial by Jamon Camisso, published on January 15,
    2022.
-   Thanks to the open-source communities for Suricata, Elasticsearch,
    Kibana, and Filebeat.

For questions or support, open an issue in this repository.
