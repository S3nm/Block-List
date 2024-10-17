Blocked IP Addresses Repository
This repository is used to store and track IP addresses that have been dynamically blocked by a Fortinet firewall. The purpose is to maintain a centralized list of risky or unauthorized IP addresses that attempt to access the SSL VPN or other protected resources. By utilizing this repository, blocked IPs can be logged, reviewed, and managed more easily than through traditional firewall group limitations.

How It Works
Dynamic Blocking on Fortinet Firewall:

When an unauthorized access attempt is detected, the Fortinet firewall identifies the IP address (%%log.remip%%) and blocks it by adding it to a local group.
Instead of relying solely on the firewall’s address groups, which may have limitations, the script logs these blocked IPs directly to this GitHub repository.
Direct Update Using GitHub API:
