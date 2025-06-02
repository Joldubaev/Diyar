# Variables
FLUTTER := flutter
POD := pod
IOS_DIR := ios

# Default target (run `make` or `make help`)
.DEFAULT_GOAL := help

.PHONY: help
help:
 @echo "Available targets:"
 @echo "  clean       - Full clean (Flutter + iOS)"
 @echo "  deps        - Install Flutter & CocoaPods dependencies"
 @echo "  build       - Build the app for iOS (debug)"
 @echo "  run         - Run the app on the default iOS simulator"
 @echo "  firebase    - Reconfigure Firebase (run flutterfire configure)"
 @echo "  pods        - Reinstall iOS pods (slow)"
 @echo "  xcode       - Open Xcode workspace"
 @echo "  kill        - Kill all Dart/Flutter processes"
 @echo "  generate    - Run build_runner to generate code"

.PHONY: clean
clean:
 @echo "Cleaning Flutter and iOS..."
 @$(FLUTTER) clean
 @rm -rf $(IOS_DIR)/Podfile.lock $(IOS_DIR)/Pods $(IOS_DIR)/.symlinks
 @echo "✅ Done."

.PHONY: deps
deps:
 @echo "Installing dependencies..."
 @$(FLUTTER) pub get
 @cd $(IOS_DIR) && $(POD) install --repo-update
 @echo "✅ Done."

.PHONY: build
build: clean deps
 @echo "Building for iOS (debug)..."
 @$(FLUTTER) build ios --debug --no-codesign
 @echo "✅ Done. Open Xcode to run or archive."

.PHONY: run
run: clean deps
 @echo "Running on iOS simulator..."
 @$(FLUTTER) run -d $(shell $(FLUTTER) devices | grep ios | head -1 | cut -d '•' -f1 | xargs)

.PHONY: firebase
firebase:
 @echo "Reconfiguring Firebase..."
 @$(FLUTTER) pub global run flutterfire_cli:flutterfire configure
 @echo "✅ Done. Re-run 'make deps' if needed."

.PHONY: pods
pods:
 @echo "Reinstalling iOS Pods..."
 @rm -rf $(IOS_DIR)/Podfile.lock $(IOS_DIR)/Pods
 @cd $(IOS_DIR) && $(POD) install --repo-update
 @echo "✅ Done."

.PHONY: xcode
xcode:
 @echo "Opening Xcode..."
 @open $(IOS_DIR)/Runner.xcworkspace

.PHONY: kill
kill:
 @echo "Killing Dart/Flutter processes..."
 @pkill -f Dart || true
 @pkill -f flutter || true
 @echo "✅ Done."

.PHONY: generate
generate:
 @echo "Generating code with build_runner..."
 @$(FLUTTER) pub run build_runner build --delete-conflicting-outputs
 @echo "✅ Code generation complete."