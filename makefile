default:
	@pkill -f '/Applications/Xcode(-beta)?.app/Contents/MacOS/Xcode' || true
	@tuist generate --open

major::
	@scripts/release.rb major

minor::
	@scripts/release.rb minor
