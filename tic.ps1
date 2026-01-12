$TicketsRoot = "D:\Tickets"
$TemplatesRoot = "D:\tools\templates"

$help=$false
$action=""
$ticket=""
$options=@{}

$actions=@(
    "create",
    "delete",
    "cd"
)

function get_action() {
    param(
        [string]$action
    )

    if ($actions.Length -eq 0) {
        return -1
    }

    $action_idx = -1
    foreach ($i in 0..($action.Length - 1)) {
        $alias = $action.Substring(0, $i + 1)

        foreach ($j in 0..($actions.Length - 1)) {
            $min_len = $($($i+1),$actions[$j].Length | Measure-Object -Minimum).Minimum
            $action_alias = $actions[$j].Substring(0, $min_len)
            if ($action_alias -ne $alias) {
                continue
            }
            if ($action_idx -ge 0) {
                $action_idx = -1
                break
            }
            $action_idx = $j
        }

        if ($action_idx -ge 0) {
            break
        }
    }

    return $action_idx
}

foreach ($arg in $args) {
    if ($arg[0] -eq "-") {
        if ($arg -eq "-h" -or $arg -eq "--help") {
            $help=$true
        }
        elseif ($arg -eq "-m" -or $arg -eq "--mop") {
            $options["mop"] = $true
        }
        else {
            Write-Host "Invalid Option $arg"
            exit 1
        }
    }
    else {
        if ($action.Length -gt 0) {
            $ticket = $arg
        }
        else {
            $idx = $(get_action $arg)
            if ($idx -eq -1) {
                $action = $arg
            }
            else {
                $action = $actions[$idx]
            }
        }
    }
}

function help() {
    Write-Host "Usage:"
    Write-Host "tic [Action] [Options] <Ticket>"
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  create            Creates a directory for the <Ticket>"
    Write-Host "  delete            Deletes a directory for the <Ticket>"
    Write-Host "  cd                cd to <Ticket>, if <Ticket> does not exist cd to ${TicketsRoot}"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -h, --help        Print this help message and exit"
    Write-Host "  -m, --mop         Append `_MOP` to <Ticket> also creates a MOP and Scripts Folder"
}

if ($help -eq $true) {
    help
    exit 0
}

function create_name() {
    param(
        [string]$prefix,
        [string]$ticket
    )

    if ($ticket.Length -gt 0) {
        return "${prefix}_US${ticket}_SSCGII360_MAASUNCION_$(Get-Date -UFormat "%Y%m%d")"
    }
    else {
        return "${prefix}_SSCGII360_MAASUNCION_$(Get-Date -UFormat "%Y%m%d")"
    }
}

switch ($action) {
    "create" {
        if ($ticket.Length -eq 0) {
            Write-Host "<Ticket> cannot be empty"
            exit 1
        }

        $s_mop = ""
        if ($options["mop"] -eq $true) {
            $s_mop = "_MOP"
        }

        New-Item -Path "${TicketsRoot}\${ticket}${s_mop}\" -ItemType Directory
        if ($options["mop"] -eq $true) {
            New-Item -Path "${TicketsRoot}\${ticket}${s_mop}\MOP" -ItemType Directory && `
                Copy-Item "${TemplatesRoot}\MOP.docx" "${TicketsRoot}\${ticket}${s_mop}\MOP\$(create_name "MOP").docx"

            New-Item -Path "${TicketsRoot}\${ticket}${s_mop}\Scripts" -ItemType Directory
        }
    }
    "delete" {
        if ($ticket.Length -eq 0) {
            Write-Host "<Ticket> cannot be empty"
            exit 1
        }

        $folder = Get-ChildItem -Path $TicketsRoot -Directory -Filter "$ticket*" | Select-Object -First 1

        if ($folder) {
            Write-Host "Deleting $($folder.FullName)"
            Remove-Item  -R -Force $folder.FullName
        }
        else {
            Write-Host "$ticket Does not exists"
        }
    }
    "cd" {
        if ($ticket.Length -eq 0) {
            Set-Location $TicketsRoot
        }
        else {
            $folder = Get-ChildItem -Path $TicketsRoot -Directory -Filter "$ticket*" | Select-Object -First 1
            echo $folder

            if ($folder) {
                Set-Location $folder.FullName
            }
            else {
                Set-Location $TicketsRoot
            }
        }
    }
    default {
        Write-Host "Invalid Action"
        help
        exit 1
    }
}
