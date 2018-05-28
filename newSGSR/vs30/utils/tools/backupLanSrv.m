disp('Copying data to LAN server...');

String1 = ['cd /home/datawriter/Spikes/' Experimenter '\n'];
escapeZip = strrep(zipName, '\', '\\');
String2 = ['put "' escapeZip '"' '\n'];
String3 = ['quit' '\n'];
delete 'C:\SGSRdevelop\SGSR\vs30\utils\tools\psftp\ULscript.ftp'
if exist('C:\SGSRdevelop\SGSR\vs30\utils\tools\psftp\ULscript.ftp', 'file')
    warning('Error copying to LAN server: could not delete old FTP script');
else
    fid = fopen('C:\SGSRdevelop\SGSR\vs30\UTILS\TOOLS\psftp\ULscript.ftp', 'w');
    fprintf(fid, String1);

    fprintf(fid, String2);
    fprintf(fid, String3);
    status = fclose(fid);

    if ~exist('C:\SGSRdevelop\SGSR\vs30\UTILS\TOOLS\psftp\ULscript.ftp', 'file')
        warning('Error copying to LAN server: could not create FTP script');
    else
        eval(['!C:\SGSRdevelop\SGSR\vs30\UTILS\TOOLS\psftp\psftp.exe datawriter@lan-srv-01.med.kuleuven.be -pw 5monkey -b C:\SGSRdevelop\SGSR\vs30\UTILS\TOOLS\psftp\ULscript.ftp']);
        disp('Finished attempt to copy data to LAN server.');
    end
end



