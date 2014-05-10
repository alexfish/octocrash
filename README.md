# OctoCrash

[![Build Status](https://api.travis-ci.org/alexfish/octocrash.png?branch=master,develop)](https://travis-ci.org/alexfish/octocrash)

A Github issue crash reporter for iOS.

## Dependencies

OctoCrash requires a GitHub OAuth application to authenticate your users with GitHub to report issues. 

Create an application at [https://github.com/settings/applications/new](https://github.com/settings/applications/new) taking note of the applications client id and secret. 

**Note:** The Callback URL is not important as OctoCrash authenticates via an alert UI.

## Usage

Import OctoCrash in your application delegate

    #import <OctoCrash/OctoCrash.h>

Configure OctoCrash by setting the *repository name* to report issues to as well as your Github OAuth applications *client id* and *client secret* in the following format. 

    [[AEFCrashReporter sharedReporter] setRepo:@"user/repo"
                                      clientID:@"client_id"
                                  clientSecret:@"client_secret"];

Start capturing crashes

    [[AEFCrashReporter sharedReporter] startReporting];

### Labels

As of verson 0.2.0 it is possible to apply labels to crash report issues by setting the labels property before starting reporting:

    [[AEFCrashReporter sharedReporter] setLabels:@[@"bug", @"crash"]];

## Installation

1. Add the repository as a submodule of your application's repository.
2. Run `bootstrap/script` from within the OctoCrash folder.
3. Drag and drop `OctoCrash.xcproj` into your application's project file or workspace.
4. Add `-lOctoCrash`, `-lISO8601DateFormatter.a` and `-framework CrashReporter` to your targets  `Other Linker Flags`. It's highly recommended to only add these flags to your `Debug` or `InHouse` targets as OctoCrash is not designed for production. 
5. Add `AEFLocalizable.strings` to your application's `Copy Bundle Resources` build phase.

Due to some dependency issues OctoCrash is not currently available through Cocoapods, check the `feature/cocoapods` branch for the podspec.

## Author

Alex Fish, alex@alexefish.com

## License

OctoCrash is available under the MIT license. See the LICENSE file for more info.

