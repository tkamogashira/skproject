function s = servername
%SERVERNAME returns name of computer that is configured as the SGSR-server
%
%   Attention! This version of the network-interface uses mapped network drives instead of a directly exploiting
%   the network facilities. So the name of the server computer in the LAN is the drive letter that is associated 
%   with the computer, it should be S. (Using the JAVA API will overcome this minor problem in the future)
%
%   See also SERVERDIR, COMPUNAME

%B. Van de Sande 24-09-2003

s = 'L:';
