# AutoResolvedPods (Swift)

Command Line Tools untuk resolved pod setiap kali pindah branch yang berisi 3 command yaitu:
1. bundle exec pod deintegrate
2. bundle exec pod install
3. xcodebuild -resolvePackageDependencies

## Cara install
* git clone repository ini
* masuk folder proyek ini menggunakan terminal
* open AutoResolvedPods.swift rubah dengan path project kalian let projectDirectory = "/your/PATH/" terus save
* swift AutoResolvedPods.swift             
