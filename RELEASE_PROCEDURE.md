# Release procedure

## Pre-release

Before releasing, it is always a good idea to make sure every piece of work in the SDK has been tested and QA'd and is approved for release. It is also a good idea to ensure any dependencies we rely on are also up-to-date.

## Making a tag

1- In `Configurations/Afterpay-Shared.xcconfig`, update the `MARKETING_VERSION` to the number you wish to release. Please follow [semantic versioning](https://developer.apple.com/documentation/swift_packages/version).

2- Update the versions recommended in the ReadMe Integration Guide. For example, in the instructions for how to integrate with SPM, Carthage, etc, update the versions there.

3- Push all changes to GitHub.

4- In GitHub, go to `Releases` and click `Draft a new release`. Insert the version number as the tag version. Fill in the rest of details of the release as well with as much detail as you can, particularly noting any breaking changes. GitHub Actions will have already filled in many of the changes for you from pull requests titles, but you will need to make this more human-readable.

### Extra notes for CocoaPods

In order to [deploy a library to CocoaPods](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#deploying-a-library), it is necessary to push our `Afterpay.podspec` file. This is handled automatically by a [GitHub Action](https://github.com/afterpay/sdk-ios/actions/workflows/deploy_to_cocoapods.yml). Whenever you make a new release tag in GitHub, this Action will deploy the podspec to the CocoaPods Trunk for you.

The GitHub Action needs a `COCOAPODS_TRUNK_TOKEN` to be set. This is the secret token which authenticates us with CocoaPods. To get this [register with CocoaPods](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#getting-started) and then be [added as a contributor](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#adding-other-people-as-contributors).

[This blog post](https://medium.com/swlh/automated-cocoapod-releases-with-github-actions-8526dd4535c7) outlines a similar procedure.

### Swift Package Manager & Carthage

Swift Package Manager and Carthage require no additional work. Those package managers will automatically start receiving the new version when they can. 
