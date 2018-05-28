function [Device, Directory, FileName, FileExt, Version] = unravelVMSPath(Path)
%UNRAVELVMSPATH extract parts of VMS path specification
%   [Device, Directory, FileName, FileExt, Version] = unravelVMSPath(Path)
%
%   VMS Path Specifications include three basic elements:
%    * Device
%    * Directory
%    * Filename.Extension;Version
%   All of these elements are always in upper case and are not case sensitive or
%   case preserving.
%   
%   Example: DKA0:[MYDIR.SUBDIR1.SUBDIR2]MYFILE.TXT;1
%
%   Filename.Extension;Version
%   This portion of the VMS Path Specification is the most complex. Like DOS and unlike UN*X,
%   it has a structure. Each element of the structure is significant. The "Filename" and 
%   ".Extension" portions can each contain up to 39 characters. However, only one "dot" (".", a period)
%   can appear in this portion of the VMS Path Specification. You'll see why later.
%   The ".Extension" portion is significant, like in DOS. When you run a program or invoke a command, 
%   the "image activator" looks for files with a ".EXE" extension by default. (A default value is one
%   that is used when you do not specify a value explicitly.) When you invoke a command procedure 
%   (using the "@" operator), DCL looks for a file with a .COM extension by default.
%   The "Filename" and ".Extension" portions can contain characters from "A" to "Z", "0" to "9", 
%   "$" (a dollar sign), "_" (an underscore), or "-" (a dash or hyphen). No other "special" characters
%   are allowed. Avoid the "$" (dollar sign) and "-" (hyphen) characters for ISO-9660 compatibility.
%   The ";Version" portion represents a version number which can range from 1 to 32767 (the maximum 
%   positive value that can be expressed in a signed word integer). This concept is foreign to both
%   DOS and UN*X. Note that on UN*X you can include, for example, ";1" at the end of a filename, 
%   as in "/usr/mydir/myfile.txt;1". However, the ";1" portion of a filename is meaningless to UN*X
%   itself or the shell, although the smei-colon (";") can have a special meaning to some shells.
%   On OpenVMS, the first version of a file has the version number ";1". Each subsequent version 
%   receives a higher version number. When files are listed, or when "searching" for files
%   (F$SEARCH() in DCL, or LIB$FIND_FILE in a program), files are located in descending order by their
%   version number, but alphabetically by name and extension.
%
%   Directory
%   The Directory portion of a VMS Path Specification indicates the path through the directory structure
%   to a file. This is the only portion of a VMS Path Specification which can contain multiple "dots" 
%   (".", periods). The dots are used to delimit directories in the path, much the same way that UN*X uses
%   slashes and DOS uses back-slashes. The entire expression is enclosed in square brackets ("[]").
%   Like DOS or UNIX, a directory is a special kind of file. Although it always has an extension of .DIR
%   (unlike DOS or UN*X), there is a special flag which indicates that the file is a directory (like DOS or UN*X).
%   This "attribute" of the file is only visible using DUMP/HEADER or DIRECTORY/FULL.
%
%   Device
%   The Device portion of a VMS Path Specification can be the most deceiving. It can be a physical device name, 
%   a "logical name" which equates to a physical device name, a "logical name" which equates to a physical 
%   (or logical!) device name plus the entire path (a "non-rooted" logical name), or a "logical name" which 
%   equates to a physical device name plus a portion of a path (a "rooted" logical name).
%   By contrast, DOS uses only a single letter (a "drive letter"). The concept is foreign to UN*X because the
%   whole of the available disk storage is viewed in UN*X as a single resource, regardless of how many physical
%   devices that may include.
%
%   The VMS device name also has a structure. The expression "ddcu" is often used in examples to represent the 
%   device name. In "ddcu:": the "dd" portion indicates the device type (two(2) letters); the "c" portion 
%   indicates the controller number relative to first controller for that device type in the system (one(1) letter,
%   "A" thru "Z"); the "u" portion indicates the unit number of the device on the controller (one(1) to four(4) 
%   digits, "0" thru "9999").
%
%   Examples of Device Types:
%    * DU - Generic Disk
%    * DK - SCSI Disk
%    * DI - DSSI Disk
%    * DS - Shadowed Disk ("Host" based shadowing)
%    * MU - Generic Tape
%    * MK - SCSI Tape
%    * MI - DSSI Tape
%
%   Examples of Device Names:
%    * DUA0:
%    * DKA300:
%    * RF0C11$DIA1:
%    * DSA20:
%    * MUA0:
%    * MKA500:
%    * TF0C10$MIA0

%B. Van de Sande 26-04-2004

%Checking input arguments ...
if (nargin ~= 1) | ~ischar(Path), error('Wrong input arguments.'); end

%Extract device name ...
idx = min(findstr(Path, ':'));
if isempty(idx), Device = '';
else, 
    Device = lower(Path(1:idx-1)); 
    Path(1:idx) = [];
end

%Extract directory ...
Bidx = min(findstr(Path, '['));
Eidx = max(findstr(Path, ']'));
if isempty(Bidx) & isempty(Eidx), Directory = ''; 
else, 
    Directory = lower(Path(Bidx+1:Eidx-1));
    Directory(findstr(Directory, '.')) = '\';
    Path(1:Eidx) = [];
end

%Extract version number ...
idx = findstr(Path, ';');
if ~isempty(idx) & (length(idx) == 1), Version = str2num(Path(idx+1:end));
else, Version = []; end
Path(idx:end) = [];

%Extract filename and extension ...
[Dummy, FileName, FileExt] = fileparts(Path);
[FileName, FileExt] = deal(lower(FileName), lower(FileExt));