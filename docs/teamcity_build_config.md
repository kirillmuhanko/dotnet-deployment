## TeamCity Configuration Details

### Branch Specification
- **Branch**: `refs/heads/*`
  - Builds all branches.

### Artifact Paths
- **Artifacts**: `+:./dist => demo.%build.number%-%teamcity.build.branch%.zip`
  - Archives files in `./dist` with build number and branch name.

### Output Directory
- **Output**: `./dist`
  - Location for build artifacts.
