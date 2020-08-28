default:
	@pkill -f '/Applications/Xcode(-beta)?.app/Contents/MacOS/Xcode' || true
	@tuist generate
	@xed .
