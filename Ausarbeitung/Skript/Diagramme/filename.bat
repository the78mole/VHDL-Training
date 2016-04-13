    @echo off
    rem -- The indentation is part of the code! Leave it!
    rem -- Change to the drive and directory of this batch file
    %0\
    cd %0\..
    rem -- Check for proper argument
    if [%1]==[] goto HELP1
    if not [%2]==[] goto HELP2
    if not exist %1 goto HELP3
    echo %1 | find """" > nul
    if not errorlevel 1 goto HELP4
    rem -- First create the ~rootname2.bat from the un-indented lines below
    type %0 | find /v "    " > ~rootname2.bat
    rem -- Now create the ~rootname1.bat using CHOICE
    rem -- http://www.ericphelps.com/batch/charactr/index.htm#choice
    echo = | choice /c=%1= ~rootname2.bat > ~rootname1.bat
    rem -- Now run the ~rootname1.bat which will run ~rootname2.bat
    call ~rootname1.bat
    rem -- Delete both temporary ~ files
    del ~rootname?.bat
    rem -- display the answer!
    echo %rootname%
    goto END
    :HELP1
    echo You must supply an argument!
    echo.
    goto HELP
    :HELP2
    echo You must supply only one argument!
    echo.
    goto HELP
    :HELP3
    echo The argument you supplied must be a real file name!
    echo.
    goto HELP
    :HELP4
    echo You must not quote the file name!
    echo.
    goto HELP
    :HELP
    echo Drop a file on this batch file and it will return
    echo the root name in the environment variable "rootname".
    echo The file must be a non-quoted short file name (which
    echo is how Windows automatically handles dropped files).
    goto END

set rootname=
shift
:START
if [%1]==[.] goto END
set rootname=%rootname%%1
rem -- delete the below line if you want to keep the path
if [%1]==[\] set rootname=
shift
goto START
:END

::  FYI, the CHOICE command is not generally available under NT. 
::  You can get it on the disk version of the Resource Kit, but
::  not on the download version. If you really want to implement
::  this Win9x solution on NT, you can always steal a copy of 
::  CHOICE.EXE from a Win9x box. All reports I've heard say it
::  works just fine. If a Win98 box isn't handy, download it:
::  ftp://ftp.microsoft.com/Services/TechNet/samples/PS/Win98/Reskit/SCRPTING/