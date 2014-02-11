
function gs(){
  git status
}

function git-c(){
  $message = formatCommitMessage($args[0])
  git commit -m $message
  git status
}

function gpr(){
 git pull --rebase
}

function ga(){
  git add --all
  git status		
}

function gac(){
  git add --all
  $message = formatCommitMessage($args[0])
  git commit -m $message
  git status
}

function Set-GitJiraISsue(){
  $Global:CurrentJiraIssue = $args[0]
  $GitPromptSettings.BeforeText = " [AB-" + $Global:CurrentJiraIssue + " "
}


function formatCommitMessage(){
  $jiraPrefix = if ($Global:CurrentJiraIssue -eq $null -or $Global:CurrentJiraIssue -eq "") {""} else { "AB-" + $Global:CurrentJiraIssue + " "}
  return $jiraPrefix + $args[0]
}

function setJiraIssue(){
  $Global:CurrentJiraIssue = $args[0]
  $GitPromptSettings.BeforeText = " [AB-" + $Global:CurrentJiraIssue + " "
}

function clearJiraIssue(){
 $GitPromptSettings.BeforeText = " ["
}

function gfp(){
    clear
    #git status    

    $status = git status
    $trackedFiles = $status | Select-String "(deleted|modified):"
    $untrackedFiles = ($status | Select-String "Untracked" -Context 0, 999).ToString();

    
    $untrackedFiles = ($untrackedFiles -split '\r\n')
    

    ($trackedFiles + $untrackedFiles[3..($untrackedFiles.Length-2)]) | Out-GridView -PassThru

  #$status | grep "\(modified\|deleted\|new\)" | Out-GridView -passthru | file-picker
 #git status
}

function file-picker(){
$pattern = "s/^# *modified: *//"
foreach($line in $input)
 {
  $exitFlag = $line -imatch "not staged"

  $file = $line -replace "^#\s+modified:\s+", ''
  git add $file
 }
}