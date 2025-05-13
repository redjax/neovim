$NpmDependencies = @(
    "azure-pipelines-language-server"
)

foreach ($NpmPkg in $NpmDependencies ) {
    try {
        npm install -g $NpmPkg
    } catch {
        Write-Error "Error installing NPM dependency '$NpmPkg'. Details: $($Exception.Message)"
    }
}
