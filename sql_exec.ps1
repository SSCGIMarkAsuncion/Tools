$config_path = "D:\Tickets\db.conf.json"
# the json schema is
# {
#    "ProfileName": "connectionString"
# }

$config = Get-Content -Path $config_path -Raw | ConvertFrom-Json

$help=$false
$verbose=$false
$recursive=$false
$glob="*"
$profile=""
$path=""
$customProfile=""

function help() {
    Write-Host "Usage:"
    Write-Host "sql_exec <Profile> [Options] <Path>"
    Write-Host ""
    Write-Host "Profile:"
    foreach ($key in $config.PSObject.Properties.Name) {
        Write-Host "    ${key}"
    }
    Write-Host "Options:"
    Write-Host "  -h, --help                          Print this help message and exit"
    Write-Host "  -g, --glob <v>                      Filter <Path> with <v> glob."
    Write-Host "  -v, --verbose                       Pass '--verbose' to 'Invoke-Sqlcmd'"
    Write-Host "  -r, --recursive                     Execute sql scripts inside a subfolder of the <Path>"
    Write-Host "  -c, --custom-profile <con_str>      Create a profile with name 'Custom' and with value of <con_str>. NOTE: the <Profile> must be set to 'Custom'."
    Write-Host "NOTE:"
    Write-Host "    This script requires the module 'SqlServer'"
}

for ($i = 0; $i -lt $args.Count; $i++) {
    $arg = $args[$i]
    if ($arg[0] -eq "-") {
        if ($arg -eq "-h" -or $arg -eq "--help") {
            $help=$true
        }
        elseif ($arg -eq "-g" -or $arg -eq "--glob") {
            $glob = $args[$i+1]
            $i++;
        }
        elseif ($arg -eq "-v" -or $arg -eq "--verbose") {
            $verbose = $true
        }
        elseif ($arg -eq "-r" -or $arg -eq "--recursive") {
            $recursive = $true
        }
        elseif ($arg -eq "-c" -or $arg -eq "--custom-profile") {
            $customProfile = $args[$i+1]
            $i++
        }
        else {
            Write-Host "Invalid Option $arg"
            exit 1
        }
    }
    else {
        if ($profile.Length -eq 0) {
            $profile = $arg
        }
        elseif ($path.Length -eq 0) {
            $path = $arg
        }
        else {
            Write-Host "Invalid Value $arg"
            exit 1
        }
    }
}


if ($help -eq $true)
{
    help
    exit 0
}

if ($profile.Length -eq 0) {
    Write-Host "Profile is not defined."
    exit 1
}

if ($path.Length -eq 0) {
    Write-Host "Path is not defined."
    exit 1
}

if (-not $(Test-Path -Path $path -PathType Container)) {
    Write-Host "${path} is not a directory."
    exit 1
}

$connectionString = ""
if ($profile -eq "Custom") {
    $connectionString = $customProfile
}
else {
    $connectionString = $config.$profile
}
Write-Host "Using connection string: ${connectionString}"

function _sql_exec() {
    param (
        [string]$DirPath
    )

    foreach ($f in $(Get-ChildItem $DirPath -Filter $glob)) {
        $fullPath = $f.FullName
        if ($recursive -and $(Test-Path -Path $fullPath -PathType Container)) {
            _sql_exec -DirPath $fullPath
            continue
        }
        if ([System.IO.Path]::GetExtension($f.Name) -ne ".sql") {
            Write-Host "Skipping ${fullPath} not a sql file."
            continue
        }

        $content = $(Get-Content -Raw $fullPath)
        if ($profile -eq "Custom" -and $connectionString.Length -eq 0) {
            Write-Host "${profile} value is empty."
            break
        }
        elseif ($connectionString.Length -eq 0) {
            Write-Host "${profile} is not a valid Profile. Check ${config_path} for the profiles."
            break
        }

        $params = @{
            Query = "${content}"
            ConnectionString = $connectionString
        }

        if ($verbose -eq $true) {
            $params.Verbose = $true
        }

        Write-Host "===================="
        Write-Host "Executing '${fullPath}'..."
        Write-Host ""

        Invoke-Sqlcmd @params

        Write-Host "Done executing '${fullPath}'. Invoke-Sqlcmd exited with status ${LASTEXITCODE}"
        Write-Host "===================="
    }
}

_sql_exec -DirPath $path
