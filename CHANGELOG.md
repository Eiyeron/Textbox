# Changelog

## Next version
### Changed
- Textbox's `advanceCharacter` function has been cleaned.
- General Textbox codestyle cleaning.
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