# imchat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


protoc --dart_out=../lib/proto ./**/*.proto


protoc --dart_out= /Users/sy/Documents/GitHub/IMChat/imchat/lib/protobuf/dart /Users/sy/Documents/GitHub/IMChat/imchat/lib/protobuf/proto/*.proto

protoc -I  /Users/sy/Documents/GitHub/IMChat/imchat/lib/protobuf/dart  --dart_out=/Users/sy/Documents/GitHub/IMChat/imchat/lib/protobuf/dart  /Users/sy/Documents/GitHub/IMChat/imchat/lib/protobuf/proto/*.proto --plugin ~/.pub-cache/bin/protoc-gen-dart 


