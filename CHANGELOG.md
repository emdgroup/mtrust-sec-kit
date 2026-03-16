## 3.0.0-4
Released on: 3/16/2026, changelog automatically generated.


### Bug Fixes

- rethrow instead of silently returning null in prime() ([4241737](commit/4241737))
- throw SecReaderException instead of raw Exception in getModelInfo() ([685378a](commit/685378a))
- correct copy-paste error message in getDeviceId() ([29f740d](commit/29f740d))
- properly add exception details to LdExceptionMapper for error handling ([33ea85b](commit/33ea85b))
### Features

- enrich verification failure callback with exception details ([ea8d7fa](commit/ea8d7fa))
- Add exception to onVerificationFailed callback, improve error handling, add API Guard to CI ([422d320](commit/422d320))

### API Changes

#### 💣 Breaking changes

**`class` CmdWrapper** ([package:mtrust_urp_core/src/command_wrapper.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-7b1735aa9bc600d87769d9fec5da68dfbf9e70528a4d0aab28fa06d01f97062f))
- ❌ Method removed: `pair`

**`class` DeviceError** ([package:mtrust_urp_core/src/exceptions.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-6cbf5223db9c1a2e090610fb6b22e40ade6c975b0cf06c241c3c9ccd1f2f6665))
- 🔄 Param type changed in default constructor: `errorCode` (`int` → `UrpErrorCode`)
- 🔄 Property type changed: `errorCode`

**`class` SECReader** ([lib/src/sec_reader.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-67ceb7d89da651b6536cb0d5b1c155e28a519252c85af02fe960fe85cc5c7bb2))
- ❌ Method removed: `pair`
- 🔄 Method type changed: `prime` (`Future<UrpSecPrimeResponse?>` → `Future<UrpSecPrimeResponse>`)

**`class` SecConnectionFailedException** ([lib/src/sec_reader_exception.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-dd99aadeb7c0e7dd8d9b3e853b65f13fc48f88ff583f0ab8d7513d1a7a7e71f3))
- ❌ Class removed: `SecConnectionFailedException`

**`class` SecModalBuilder** ([lib/src/ui/sec_modal.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-a3f90834e96f20c6e781d4aa966775c2ade88e8317af0950f807ac3a6404ff31))
- 🔄 Param type changed in default constructor: `onVerificationFailed` (`void Function()` → `void Function(SecReaderException)`)
- 🔄 Property type changed: `onVerificationFailed`

**`class` SecResultFailed** ([lib/src/ui/sec_modal.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-a3f90834e96f20c6e781d4aa966775c2ade88e8317af0950f807ac3a6404ff31))
- ❇️ Param added in default constructor: `exception` (positional, required)

**`class` SecWidget** ([lib/src/ui/sec_widget.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-c1cc8b6749cd6ce41cf838e2622be26d0f963f7169b53983c57f2ec6cd22fac2))
- 🔄 Param type changed in default constructor: `onVerificationFailed` (`Future<void> Function()` → `Future<void> Function(SecReaderException)`)
- 🔄 Property type changed: `onVerificationFailed`

#### ✨ Minor changes

**`class` CmdWrapper** ([package:mtrust_urp_core/src/command_wrapper.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-7b1735aa9bc600d87769d9fec5da68dfbf9e70528a4d0aab28fa06d01f97062f))
- ❌ Modifier `abstract` removed from methods: `ping`, `info`, `getPower`, `setName`, `getName`, `unpair`, `startAP`, `stopAP`, `connectAP`, `disconnectAP`, `startDFU`, `stopDFU`, `sleep`, `off`, `reboot`, `stayAwake`, `getPublicKey`, `getDeviceId`, `identify`
- ❇️ Methods added: `addCoreCmdToQueue`, `getVersion`

**`class` ConnectionStrategy** ([package:mtrust_urp_core/src/connection_strategy.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-89390ebaa82697a717dc3a7fc72f2336f9ad80fd0abb429444850482b56af5f7))
- ❇️ Property added: `onRequestCallback`

**`class` SECReader** ([lib/src/sec_reader.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-67ceb7d89da651b6536cb0d5b1c155e28a519252c85af02fe960fe85cc5c7bb2))
- ❇️ Methods added: `addCoreCmdToQueue`, `getVersion`

**`class` SecReaderException** ([lib/src/sec_reader_exception.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-dd99aadeb7c0e7dd8d9b3e853b65f13fc48f88ff583f0ab8d7513d1a7a7e71f3))
- ❇️ Constructor added: `from`

**`enum` SecReaderExceptionType** ([lib/src/sec_reader_exception.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-dd99aadeb7c0e7dd8d9b3e853b65f13fc48f88ff583f0ab8d7513d1a7a7e71f3))
- ❇️ Properties added: `connectionFailed`, `commandFailed`

**`class` SecResultFailed** ([lib/src/ui/sec_modal.dart](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-a3f90834e96f20c6e781d4aa966775c2ade88e8317af0950f807ac3a6404ff31))
- ❇️ Property added: `exception`

#### 👀 Patch changes

**`meta` dependency `mtrust_urp_core`** ([pubspec.yaml](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-8b7e9df87668ffa6a04b32e1769a33434999e54ae081c52e5d943c541d4c0d25))
- 📦 Dependency version changed: from `9.1.0-12` to `^9.1.0-13`

**`meta` dependency `mtrust_urp_types`** ([pubspec.yaml](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-8b7e9df87668ffa6a04b32e1769a33434999e54ae081c52e5d943c541d4c0d25))
- 📦 Dependency version changed: from `^6.2.0` to `^6.2.1`

**`meta` dependency `mtrust_urp_ui`** ([pubspec.yaml](https://github.com/emdgroup/mtrust-sec-kit/compare/v3.0.0-3..v3.0.0-4#diff-8b7e9df87668ffa6a04b32e1769a33434999e54ae081c52e5d943c541d4c0d25))
- 📦 Dependency version changed: from `9.1.0-12` to `^9.1.0-13`


# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## 3.0.0-3 (2026-02-16)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* liquid flutter 22 ([#14](https://github.com/emdgroup/mtrust-sec-kit/issues/14)) ([648d0f8](https://github.com/emdgroup/mtrust-sec-kit/commit/648d0f80a4c59d3f4a52994765aa1e6bd05f601f))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* format code ([8dd1a47](https://github.com/emdgroup/mtrust-sec-kit/commit/8dd1a4713b6842029a59db29ae90fd75a027ed87))
* mtu size ([aff1ce9](https://github.com/emdgroup/mtrust-sec-kit/commit/aff1ce93e6e7550fdd8de1b6801ba640ec2a9df8))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))
* token error message ([849c40f](https://github.com/emdgroup/mtrust-sec-kit/commit/849c40fccc49e47009d3b0c0fe372f731fab0f75))
* token error message position and title size, update readme ([22703c5](https://github.com/emdgroup/mtrust-sec-kit/commit/22703c5cbe53d8351d82b09ef93824b20ce5bbcf))
* untrack build artefacts ([094ee4f](https://github.com/emdgroup/mtrust-sec-kit/commit/094ee4fa50066cb413e07302eb537181b8981630))
* untrack example/pubspec.lock ([0cb56fc](https://github.com/emdgroup/mtrust-sec-kit/commit/0cb56fc4727bee3871ff293f2c21c3b2606886e2))
* update .gitignore to untrack generated files and build artifacts ([0dab361](https://github.com/emdgroup/mtrust-sec-kit/commit/0dab361958a8e6ff45be8ceb3d4ecd97d7686809))
* update mtrust_urp_core and mtrust_urp_ui dependencies to remove version constraints ([85605f7](https://github.com/emdgroup/mtrust-sec-kit/commit/85605f74b43d36df02680211b167e96acbfd37a6))

## 3.0.0-2 (2026-02-16)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* liquid flutter 22 ([#14](https://github.com/emdgroup/mtrust-sec-kit/issues/14)) ([648d0f8](https://github.com/emdgroup/mtrust-sec-kit/commit/648d0f80a4c59d3f4a52994765aa1e6bd05f601f))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* mtu size ([aff1ce9](https://github.com/emdgroup/mtrust-sec-kit/commit/aff1ce93e6e7550fdd8de1b6801ba640ec2a9df8))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))
* token error message ([849c40f](https://github.com/emdgroup/mtrust-sec-kit/commit/849c40fccc49e47009d3b0c0fe372f731fab0f75))
* token error message position and title size, update readme ([22703c5](https://github.com/emdgroup/mtrust-sec-kit/commit/22703c5cbe53d8351d82b09ef93824b20ce5bbcf))
* untrack example/pubspec.lock ([0cb56fc](https://github.com/emdgroup/mtrust-sec-kit/commit/0cb56fc4727bee3871ff293f2c21c3b2606886e2))
* update mtrust_urp_core and mtrust_urp_ui dependencies to remove version constraints ([85605f7](https://github.com/emdgroup/mtrust-sec-kit/commit/85605f74b43d36df02680211b167e96acbfd37a6))

## 3.0.0-1 (2025-06-11)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* liquid flutter 22 ([#14](https://github.com/emdgroup/mtrust-sec-kit/issues/14)) ([648d0f8](https://github.com/emdgroup/mtrust-sec-kit/commit/648d0f80a4c59d3f4a52994765aa1e6bd05f601f))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))
* token error message ([849c40f](https://github.com/emdgroup/mtrust-sec-kit/commit/849c40fccc49e47009d3b0c0fe372f731fab0f75))
* token error message position and title size, update readme ([22703c5](https://github.com/emdgroup/mtrust-sec-kit/commit/22703c5cbe53d8351d82b09ef93824b20ce5bbcf))

## 3.0.0-0 (2025-06-06)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* liquid flutter 22 ([#14](https://github.com/emdgroup/mtrust-sec-kit/issues/14)) ([648d0f8](https://github.com/emdgroup/mtrust-sec-kit/commit/648d0f80a4c59d3f4a52994765aa1e6bd05f601f))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))
* token error message ([849c40f](https://github.com/emdgroup/mtrust-sec-kit/commit/849c40fccc49e47009d3b0c0fe372f731fab0f75))
* token error message position and title size, update readme ([22703c5](https://github.com/emdgroup/mtrust-sec-kit/commit/22703c5cbe53d8351d82b09ef93824b20ce5bbcf))

## 2.0.0 (2025-03-19)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))

## 2.0.0-7 (2025-03-19)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* show installed models, show model on verification success ([ea5b681](https://github.com/emdgroup/mtrust-sec-kit/commit/ea5b6810acbd61dfa32f899d0d6b621f7f5f9edd))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))

## 2.0.0-6 (2025-03-06)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* api exception handling ([60c4043](https://github.com/emdgroup/mtrust-sec-kit/commit/60c4043278a7e6375cdb8ba4be785157668d9ce5))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))

## 2.0.0-5 (2025-02-27)


### ⚠ BREAKING CHANGES

* change measurement structure - UrpSecSecureMeasurement
* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* change measurement structure - UrpSecSecureMeasurement ([e740eb1](https://github.com/emdgroup/mtrust-sec-kit/commit/e740eb18ff3c8bf34ff16228184ca2a0b9fd0156))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))

## 2.0.0-4 (2025-02-24)


### ⚠ BREAKING CHANGES

* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))
* remove fixed size for modal ([52d6f8e](https://github.com/emdgroup/mtrust-sec-kit/commit/52d6f8e7c3df4aed2798da2f74c5f2921fdc66ef))

## 2.0.0-3 (2025-02-23)


### ⚠ BREAKING CHANGES

* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* adjustable modal size, dismiss button displayed only if canDism… ([#5](https://github.com/emdgroup/mtrust-sec-kit/issues/5)) ([8903781](https://github.com/emdgroup/mtrust-sec-kit/commit/89037811f38054b4a45f438426417e368e055d21))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))

## 2.0.0-2 (2025-02-21)


### ⚠ BREAKING CHANGES

* token (#4)
*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* token ([#4](https://github.com/emdgroup/mtrust-sec-kit/issues/4)) ([f8645ba](https://github.com/emdgroup/mtrust-sec-kit/commit/f8645ba524dd4fdd9e0a6d981448ff5764015ba4))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))

## 2.0.0-1 (2025-02-11)


### ⚠ BREAKING CHANGES

*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))
* update to liquid flutter 19 ([0439bb0](https://github.com/emdgroup/mtrust-sec-kit/commit/0439bb0988e92d7d6f92261506857bf9964cc5e7))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))

## 2.0.0-0 (2025-01-16)


### ⚠ BREAKING CHANGES

*  liquid 18 (#2)

### Features

*  liquid 18 ([#2](https://github.com/emdgroup/mtrust-sec-kit/issues/2)) ([3f8dde0](https://github.com/emdgroup/mtrust-sec-kit/commit/3f8dde0d45a55918939741ca5cefc8aced789cf2))


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))

### 1.0.2-0 (2025-01-10)


### Bug Fixes

* core commands getting stuck due to missing SecCommandWrapper wrapping ([817bfcf](https://github.com/emdgroup/mtrust-sec-kit/commit/817bfcf33ccae4597f3a48c6eaced74a4a813017))
* core commands timeout / getting stuck ([2483db8](https://github.com/emdgroup/mtrust-sec-kit/commit/2483db84c1bc470e200806a34dc0a19ff7b7166a))

### 1.0.1 (2024-11-18)

## [1.0.0-dev.1]() (2024-13-11)