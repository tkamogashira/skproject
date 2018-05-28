function boolean = existmaddata(FN)
%EXISTMADDATA   Check if Madison datafile exists

%B. Van de Sande 04-07-2003
%Integratie van MADISON datafiles in SGSR

boolean = logical(1);

try CheckMadisonDataFile(FN);
catch boolean = logical(0); end    