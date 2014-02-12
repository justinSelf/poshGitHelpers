
function g-s(){
  git status
}

function g-cm(){
  $message = Format-GitCommitMessage($args[0])
  git commit -m $message
  git status
}

function g-pr(){
 git pull --rebase
}

function g-aa(){
  git add --all
  git status		
}

function g-ac(){
  git add --all
  $message = Format-GitCommitMessage($args[0])
  git commit -m $message
  git status
}

function Format-GitCommitMessage(){
  $jiraPrefix = if ($Global:CurrentJiraIssue -eq $null -or $Global:CurrentJiraIssue -eq "") {""} else { "AB-" + $Global:CurrentJiraIssue + " "}
  return $jiraPrefix + $args[0]
}

function Set-JiraIssue(){
  $Global:CurrentJiraIssue = $args[0]
  $GitPromptSettings.BeforeText = " [AB-" + $Global:CurrentJiraIssue + " "
}

function Clear-JiraIssue(){
 $GitPromptSettings.BeforeText = " ["
}

function Git-FilePicker(){    
    $status = git status
    $matches = $status | Select-String "(deleted|modified):"

    $allFiles = @()
    foreach( $match in $matches){
      $allFiles += ($match.Line -replace "\s*#\s+", '')
    }

    $untrackedFiles = ($status | Select-String "Untracked" -Context 0, 999).ToString() -split '\r\n'

    foreach($file in $untrackedFiles[3..($untrackedFiles.Length-2)]){
        $allFiles += ("new:        ") + ($file -replace "\s*#\s+", '')
    }

    $allFiles | Out-GridView -PassThru | Add-FilesToGit
}

function Add-FilesToGit(){
$pattern = "^\w+:\s+"
foreach($line in $input)
 {
  git add ($line -replace $pattern, '')
 }
}
