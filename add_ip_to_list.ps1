# Replace with your values
$repoOwner = "S3nm"
$repoName = "S3nm/Block-List"
$filePath = "blocked_ips.txt"
$branch = "main"
$token = "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"

# New IP to append
$newIP = "123.123.123.123"

# GitHub API URLs
$apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/contents/$filePath"

# Get the existing file details
$fileResponse = Invoke-RestMethod -Uri $apiUrl -Headers @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
} -Method GET

# Get the file contents and append the new IP
$fileContent = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($fileResponse.content))
$updatedContent = "$fileContent`r`n$newIP"

# Prepare the updated content in base64
$encodedContent = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($updatedContent))

# Commit message and body
$body = @{
    message = "Appending new blocked IP"
    content = $encodedContent
    sha = $fileResponse.sha
    branch = $branch
}

# Update the file in the repository
Invoke-RestMethod -Uri $apiUrl -Headers @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
} -Method PUT -Body (ConvertTo-Json $body)
