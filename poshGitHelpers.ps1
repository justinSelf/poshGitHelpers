
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