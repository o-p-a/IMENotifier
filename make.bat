pushd "%~dp0"
pushd "a2e"
set TGT=IMENotifier
ahk2exe /in ..\%TGT%.ahk /icon ..\%TGT%.ico
popd
popd
