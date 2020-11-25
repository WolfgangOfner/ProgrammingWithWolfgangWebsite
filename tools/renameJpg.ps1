Set-Location -Path ../

echo "Current path: $($PWD)"
echo "Starting to rename files from JPG to jpg"

Get-Childitem -Recurse | Where-Object {$_.Extension -cmatch "JPG"} | Rename-Item -NewName { $_.Name -replace '.JPG','.jpg' }

echo "Finished renaming files form JPG to jpg"