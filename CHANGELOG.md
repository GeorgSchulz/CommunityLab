# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- communitylab#26: Error handling in Conda Package Manager

## [v1.6.0] - 2025-04-28

### Added

- communitylab#63: Extend GitHub Action, add Mamba for conda environments, update JupyterHub and JupyterLab
- communitylab#61: Add GitHub Action to lint and test all Ansible collections
- communitylab#59: Upgrading to PostgreSQL 17
- communitylab#57: Add new kernels for JupyterLab and upgrade software components
- communitylab#55: Enable /bin/bash as default shell in JupyterLab

## [v1.5.0] - 2024-10-21

### Added

- communitylab#53: Up to date and maintenance of all Ansible Collections - Non-HA and HA
- communitylab#50: Simplifying architecture for IDE Non-HA setup
- communitylab#48: Downgrading OpenJDK and updating documentation images

## [v1.4.0] - 2024-08-27

### Added

- communitylab#46: Testing Ansible Collections using Ansible Molecule
- communitylab#44: Use Ansible Lint on all Ansible Collections
- communitylab#35: Upgrading to Apache Hadoop 3.4.0
- communitylab#37: Upgrading to Apache Zookeeper 3.9.2
- communitylab#36: Upgrading to Apache Spark 3.5.1
- communitylab#42: Removing bugs in Yarnspawner and upgrading JupyterHub

## [v1.3.0] - 2024-08-02

### Added

- communitylab#32: Upgrading to Ubuntu 24.04
- communitylab#39: Testing Terraform deployment using Terratest
- communitylab#19: IDE HA setup: Configure OpenLDAP as backend for Kerberos server
- communitylab#31: Upgrading to PostgreSQL 16
- communitylab#18: IDE HA setup: Configure replication for both independent LDAP servers

## [v1.2.0] - 2023-10-16

### Added

- communitylab#25: Provide popular Python libraries for Data Science and documentation for IDE usage
- communitylab#23: IDE HA setup: Change LDAP server address parameter in JupyterHub configuration
- communitylab#20: Use SSSD for all LDAP clients
- communitylab#16: IDE HA setup: Automate all steps for HA failover IP in Hetzner Cloud

## [v1.1.0] - 2023-04-02

### Added

- communitylab#11: Upgrading to Hadoop latest stable release 3.3.4
- communitylab#13: Setup VMs in Hetzner Cloud using Terraform
- communitylab#8: Upgrading to Ubuntu 22.04

## [v1.0.0] - 2023-01-01

### Added
 
- communitylab#2: Example all.yml and custom inventory files
- communitylab#1: IDE setup without High Availability
- communitylab#4: Specify SSH Key for IDE setup using path of SSH Key instead of content
- communitylab#3: Git integration in JupyterLab
