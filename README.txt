Blocked IP Addresses Repository
This repository is used to store and track IP addresses that have been dynamically blocked by a Fortinet firewall. The purpose is to maintain a centralized list of risky or unauthorized IP addresses that attempt to access the SSL VPN or other protected resources. By utilizing this repository, blocked IPs can be logged, reviewed, and managed more easily than through traditional firewall group limitations.

How It Works
Dynamic Blocking on Fortinet Firewall:

When an unauthorized access attempt is detected, the Fortinet firewall identifies the IP address (%%log.remip%%) and blocks it by adding it to a local group.
Instead of relying solely on the firewall’s address groups, which may have limitations, the script logs these blocked IPs directly to this GitHub repository.
Direct Update Using GitHub API:

The Fortinet firewall uses a CLI script with HTTP requests to interact with the GitHub REST API.
When a new IP is blocked, the script fetches the existing list from blocked_ips.txt, appends the new IP, and pushes the updated file back to the repository.
This process ensures the list remains up-to-date and accessible from a central location.
How to Use
Set Up the GitHub Repository:

Clone this repository or create your own based on this template.
Make sure you have a file named blocked_ips.txt where the IP addresses will be logged.
Generate a Personal Access Token (PAT):

Create a Personal Access Token on GitHub with repo permissions. This will allow the Fortinet firewall script to authenticate and update the repository.
Store the token securely on the firewall.
Configure the Fortinet Firewall:

Modify your firewall’s CLI script to use the GitHub API. Below is a sample snippet:
bash
Copy code
# Define the variables
TOKEN="your_github_token"
REPO="username/blocked-ips"
FILE_PATH="blocked_ips.txt"
NEW_IP="%%log.remip%%"
BRANCH="main"

# Get the existing content from the file
CONTENT_URL="https://api.github.com/repos/$REPO/contents/$FILE_PATH"

# Retrieve current file's SHA (needed to update it)
FILE_SHA=$(curl -H "Authorization: token $TOKEN" $CONTENT_URL | jq -r '.sha')

# Get the existing content of the file
EXISTING_CONTENT=$(curl -H "Authorization: token $TOKEN" $CONTENT_URL | jq -r '.content' | base64 --decode)

# Append the new IP address
UPDATED_CONTENT=$(echo -e "$EXISTING_CONTENT\n$NEW_IP" | base64)

# Use the GitHub API to update the file
curl -X PUT -H "Authorization: token $TOKEN" \
     -d "{\"message\": \"Add blocked IP: $NEW_IP\", \"content\": \"$UPDATED_CONTENT\", \"sha\": \"$FILE_SHA\", \"branch\": \"$BRANCH\"}" \
     $CONTENT_URL
Automate the Process:

Schedule the script to run whenever a new IP needs to be blocked or set it up to execute based on specific triggers within the Fortinet environment.
Benefits
Centralized Management: By keeping a central list of blocked IPs, you can easily review, audit, and manage them from anywhere.
Bypass Firewall Limitations: Avoid hitting the maximum limit of address groups on the firewall by maintaining a larger list externally.
Dynamic Updating: The GitHub API integration allows for automatic updates, reducing the need for manual intervention.
Security and Maintenance
Personal Access Token Security: Ensure your PAT is stored securely and only grants the minimum necessary permissions. Rotate it periodically for added security.
Monitor Rate Limits: Be aware of GitHub’s API rate limits and monitor for any issues related to exceeding these limits.
Review Blocked IPs Regularly: Periodically review the blocked_ips.txt file to ensure there are no false positives and to maintain an accurate blocklist.
License
This project is licensed under the MIT License - see the LICENSE file for details.