function clean-i3()
{
    $proj = $args[0]

    if ( -not (Test-Path -Path "${proj}" -PathType Container))
    {
        exit 1
    }
    $rootPaths = "AMLLITE.Dal",           `
        "AMLLITE.FluentValidation",     `
        "AMLLITE.Interface",            `
        "AMLLITE.Model",                `
        "AMLLITE.Reports",              `
        "AMLLITE.Service",              `
        "AMLLITE.Test",                 `
        "AMLLITE.Web"
    $pathsToDel = "bin/", "obj/"
    foreach ($p in $rootPaths)
    {
        $parent = Join-Path -Path $proj -ChildPath $p
        foreach ($c in $pathsToDel) {
            $toDel = Join-Path -Path $parent -ChildPath $c
            if (Test-Path -Path $toDel -PathType Container)
            {
                Write-Host "Removing Path: ${toDel}"
                Remove-Item -Force -Recurse "${toDel}"
            }
        }
    }
}

function upd_web_cfg()
{
    $path=$(pwd).Path
    $old = [regex]::Escape('C:\Users\maasuncion\source\repos\Integral360PBB')
    (Get-Content -Path "AMLLITE.Web/Web.config") -replace $old, $path | Set-Content -Path "AMLLITE.Web/Web.config"
}

function cdi3()
{
    Set-Location C:\Users\maasuncion\source\repos\
}

function i3log()
{
    nvim D:\Projects\AML\I360\Integral360PBB\AMLLITE.Web\logs\i360.log
}

oh-my-posh init pwsh --eval --config '~/robbyrussell.omp.json' | Invoke-Expression
$env:GITBIN='C:\Users\maasuncion\AppData\Local\Programs\Git\usr\bin'
Set-Alias vim "C:\Users\maasuncion\AppData\Local\Programs\Git\usr\bin\vim.exe"

$env:OneDrive = 'D:\OneDrive - Systems and Software Consulting Group, Inc\'

function rm_unt()
{
    $a=@( git ls-files -o --exclude-standard --exclude-per-directory=.gitignore )
    echo "Removing paths:"
    echo $a
    foreach ($p in $a)
    {
        rm $p
    }
}

function usage() {
    Write-Output "Commands:"
    Write-Output "  usage                           prints this message"
    Write-Output "  clean-i3 <i3_proj_path>         removes the build cache of <i3_proj_path>"
    Write-Output "  cdi3                            cd to ~/source/repos/"
    Write-Output "  tic                             ``tic -h`` for more information"
    Write-Output "  i3log                           open i3 log file with ``nvim``"
    Write-Output "  upd_web_cfg                     Update web.config paths of current `Integral360PBB` project"
    Write-Output "  cb                              Common codes"
    Write-Output "  rm_unt                          rm untracked files"

}

function cb() {
    Write-Output 'Log.Info($"EXCEPTION : {GetType().Name}.{MethodBase.GetCurrentMethod().Name} {ex}\t{ex.Message}\n{ex.StackTrace}\nEND");'
}

usage
