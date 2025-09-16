$repoTag = "tag"
$ownerName = "name"

$repoUrl = "https://github.com/$ownerName/$repoTag"
$repoName = "whatever/$ownerName/$repoTag/Latest"
$dumpPath = "$repoTag/"

git clone $repoUrl $repoName
Set-Location $repoName

$commits = git rev-list --reverse --all

New-Item -ItemType Directory -Force -Path "..\$dumpPath" | Out-Null

foreach ($commit in $commits) {
    Write-Host "Dumping commit $commit"

    $commitPath = "..\$dumpPath\$commit"

    git worktree add --detach "..\temp_$commit" $commit | Out-Null

    robocopy "..\temp_$commit" $commitPath /MIR /XD ".git" /NFL /NDL /NJH /NJS /NC | Out-Null

    git worktree remove "..\temp_$commit" --force | Out-Null
}

Set-Location ..

Write-Host "All commits have been dumped into the '$dumpPath' folder."
