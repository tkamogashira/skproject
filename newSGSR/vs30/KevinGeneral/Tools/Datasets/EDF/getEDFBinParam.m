function [BP, Err] = getEDFBinParam(MP, SP)

%B. Van de Sande 08-10-2003

Err = 0;

MN = size(MP, 1);
SN = size(SP, 1);

if MN == SN, BP = [MP, SP];
elseif (MN == 1), BP = [repmat(MP, SN, 1), SP];
elseif (SN == 1), BP = [MP, repmat(SP, MN, 1)];
else, Err = 1; end  