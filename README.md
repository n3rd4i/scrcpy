## Development

### Initialize submodule

```
git submodule init
```

### Generation app icon

App icon is generated from Genymobile/scrcpy's repository. A Build-Icon powershell script is provided
to pull and generate the icon source file from a specify tag.

```
.\scripts\Build-Icon.ps1 v1.18
```

The scripts requires [`imagegick`](https://community.chocolatey.org/packages/imagegick) to be install. 

`Build-Icon.ps1` scripts generates 3 files:
- `assets/icon.ico`
- `assets/icon.sha256`
- `assets/icon.NOTICE.md`

These files should be added and commited

```
git add assets/icon.* && git commit
```

Once commited, you should update `tools\chocolateyinstall.ps1` with the corresponding commit hash (`git rev-parse HEAD`) and sha256 checksum

```ps
Get-ChocolateyWebFile -PackageName $iconPath `
  -FileFullPath $iconSrcPath `
  -Url "https://raw.githubusercontent.com/n3rd4i/scrcpy/{{ commit hash }}/assets/icon.ico" `
  -Checksum "{{ content in assets/icon.sha256 }}" `
  -ChecksumType "sha256"
```
