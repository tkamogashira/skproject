function genmupload(SourceDir, DestDir)
%GENMUPLOAD synchronize MASTER-copy of general M-files used for data analysis on OTO and MASTER-copy 
%           of SGSR on BIGSCREEN
%   GENMUPLOAD(SourceDir, DestDir).

%B. Van de Sande 01-10-2004

%Op KARNA wordt recenste versie van general M-files bijgehouden (de MASTER-kopij), door een wijziging in de
%MATLAB-path op KARNA wordt deze MASTER-kopij gebruikt voor de versie die meegeleverd wordt met de SGSR-distributie. 
%Dit is niet zo voor gelijk welke andere computer.
%Via dit programma wordt deze MASTER-kopij gekopieerd naar BIGSCREEN die de MASTER-kopij van SGSR bijhoudt. Hierdoor
%worden de twee MASTER-kopijen als het ware gesynchroniseerd.

global Versions
idx = Versions.mostRecent;
VersionDir = Versions.Dirs{idx};

CurMoreSetting = get(0, 'More'); more off;

if ~strcmpi(compuname, 'karna') | ~strcmpi(username, 'bram'), error('This program can only be run on KARNA by user Bram.'); end

switch nargin
case 0,
    SourceDir = 'C:\USR\Bram\mfiles\General\';       %Lokatie van MASTER-kopij van general M-files ...
    DestDir   = ['B:\SGSRdevelop\SGSR\' VersionDir '\BramGeneral\'];  %Lokatie op BIGSCREEN van SGSR MASTER-kopij ... 
                                                     %B:\ moet een gemapte network drive zijn naar \\bigscreen\C\ ...
case 1,
    DestDir   = ['B:\SGSRdevelop\SGSR\' VersionDir '\BramGeneral\'];
otherwise, error('Wrong number of input arguments.'); end

%Bestanden op BIGSCREEN verwijderen... zodat geen oude files achterblijven...
%Gebruik hiervoor het commando DEL met volgende opties:
%   /S : bestanden in onderliggende directories ook deleten, maar de directories zelf blijven staan
%   /Q : Quiet-mode, geen confirmatie gevraagd om bestanden te wissen
cmd = ['!del /S /Q ' DestDir ];
eval(cmd);

%Bestanden kopieren naar BIGSCREEN ...
%Gebruik hiervoor het commando XCOPY met volgende opties:
%   /E : kopieert niet enkel bestanden maar ook de onderliggende directories, inclusief lege directories
%   /Y : overwrite zonder te vragen
%   /F : displays full source and destination file names while copying
cmd = ['!xcopy ' SourceDir '* ' DestDir ' /E /Y /F'];
eval(cmd);

set(0, 'More', CurMoreSetting);