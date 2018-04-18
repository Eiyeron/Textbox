# Changelog

## Next version
### Added
- (html5) Added `characterSpacingHack` in `Settings` to replace the magic cookie used for fixing character spacing.
### Fixed
- Compilation failure when targetting html5
- Demo sample's cursor would jump on html5 due to spaces having no height.
## 0.0.2 - 2018-04-17
### Changed
- Textbox's `advanceCharacter` function has been cleaned.
- General codestyle cleaning.
- Factorized the demo sample to make callback plugin class examples.
### Fixed
- Newline in the textbox's last line would make the textbox perpetually stuck on the newline.
- Using isSpace instead of a comparison against the space character
## 0.0.1 - 2018-04-17
### Added
- Initial versioning.
- Added a sample (decorating)
### Changed
- Textbox callback members are now callback arrays to handle multiple callbacks.
- Sample folder structure and name (`sample -> samples`)
- The first sample is now in `samples/demo`
- Changed demo sample to use the new callback type.