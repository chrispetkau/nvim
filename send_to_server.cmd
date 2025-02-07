set servername=localhost:8900

:: Unfortunately, nvim's solution requires specifying the server two different
:: ways so it's not very convenient: I need to explicitly start the server to
:: be able to send files to it. But if I failed to start the server, it will
:: open terminal with the wrong v:servername.
set file=%1
if defined file (
    :: Send the file to the server.
    call nvim --server %servername% --remote-silent %*
) else (
    :: Start the server.
    call neovide.exe --maximized %* -- --listen %servername% %session%
)

:: You can use Regedit to forward file-opens that are associated with Neovide to this cmd.
:: Computer\HKEY_CLASSES_ROOT\Applications\neovide.exe\shell\open\command "C:\Users\Chris Petkau\AppData\Local\nvim\send_to_server.cmd" "%1"
