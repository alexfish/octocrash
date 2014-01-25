# OctoCrash

[![Build Status](https://api.travis-ci.org/alexfish/octocrash.png?branch=master,develop)](https://travis-ci.org/alexfish/octocrash)

Automatically create Github issues from crashes. 

OctoCrash is designed for use within your team during development, distrubute in house builds with OctoCrash enabled to capture all crashes as GitHub issues, ship to the App Store with OctoCrash at your own peril **(don't do it)**.

## Dependencies

OctoCrash requires a GitHub OAuth application to authenticate your users with GitHub to report issues. 

Create an application at [https://github.com/settings/applications/new](https://github.com/settings/applications/new) taking note of the applications client id and secret. 

**Note:** The Callback URL is not important as OctoCrash authenticates via an alert UI.

## Usage

Import OctoCrash in your application delegate

    #import <OctoCrash/OctoCrash.h>

Configure OctoCrash by setting the *repository name* to report issues to as well as your Github OAuth applications *client id* and *client secret* in the following format. 

    [[AEFCrashReporter sharedReporter] configureRepo:@"user/repo"
                                            clientID:@"client_id"
                                        clientSecret:@"client_secret"];

Start capturing crashes

    [[AEFCrashReporter sharedReporter] startReporting];

It is not recommened to ship to the App Store with OctoCrash, to be extra safe wrap OctoCrash setup in `#ifdef INHOUSE` or whatever suits your project. 

## Installation

1. Add the reporistory as a subomdule of your application's repository.
2. Run `bootstrap/script` from within the OctoCrash folder.
3. Drag and drop `OctoCrash.xcproj` into your application's project file or workspace.
4. Add `libOctoCrash.a`, `libISO8601DateFormatter.a` and `CrashReporter.framework` to your application's `Link Binary With Libraries` build phase. 
5. Add `AEFLocalizable.strings` to your application's `Copy Bundle Resources` build phase.

Due to some dependency issues OctoCrash is not currently available through Cocoapods, check the `feature/cocoapods` branch for the podspec.

## Author

Alex Fish, alex@alexefish.com

## License

OctoCrash is available under the MIT license. See the LICENSE file for more info.

