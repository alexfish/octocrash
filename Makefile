WORKSPACE = "Project/OctoCrash.xcworkspace"
SDK = "iphonesimulator"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

all:
	xcodebuild -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK)

clean:
	xcodebuild -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK) clean

test:
	xcodebuild -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK) build test | xcpretty -cs