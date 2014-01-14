WORKSPACE = "Project/OctoCrash.xcworkspace"
SDK = "iphonesimulator"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

all:
	xctool -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK)

clean:
	xctool -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK) clean

test:
	xctool -workspace $(WORKSPACE) -scheme OctoCrash -sdk $(SDK) build test