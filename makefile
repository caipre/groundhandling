default:
	@pkill -f '/Applications/Xcode(-beta)?.app/Contents/MacOS/Xcode' || true
	@tuist generate
	@xed .

major::
	@scripts/release.rb major

minor::
	@scripts/release.rb minor
