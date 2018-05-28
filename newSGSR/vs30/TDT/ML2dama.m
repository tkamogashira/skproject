function DBN=ML2DAMA(Buf, Dbn);

% function ML2DAMA(Buf, Dbn);
% copies MatLab ROW vector Buf (more precise, its real part)
% to 16-bit-integer DAMA buffer Dbn (Dbn is dama buffer number)
% if Dbn==0, or if no Dbn is specified, a
% buffer is requested from the AP2.
% If succesful, ML2DAMA returns the DBN where
% Buf is stored; if unsuccesful, DBN equals zero.
% If Buf is a matrix, its rows are stored in separate
% Dama buffers; DBN will be a column vector containing
% the DBNs of the buffers in which the rows are stored.
% In the matrix case, Dbn, if specified, must be a column
% vector having the same # of elements as the # of rows of Buf

if nargin<1, error('input arg Buf unspecified'); end;
Npts=size(Buf);
if (nargin<2), Dbn=zeros(Npts(1),1);
elseif (size(Dbn,1)~=Npts(1)), 
   error('args Buf & Dbn must have equal # rows'); 
elseif (size(Dbn,2)~=1), 
   error('Dbn must be column vector');
end;
% multiple rows: recursive call for each row
if Npts(1)>1, % different buffers for each row
   for irow=1:Npts(1), DBN(irow,1) = ml2dama(Buf(irow,:), Dbn(irow));end;
   return;
end

% from here, a single row is passed
if ~AP2present,
   DBN = storesamples(Buf, 'MatLab');
   return;
end
Npts = Npts(2);
% replace non-allocated Dbn by zero
if (s232('getaddr',Dbn)==0), Dbn=0; end;
% allocate DAMA buffer if Dbn=0
if (Dbn==0), Dbn=APOS_allot16(Npts); end;
DBN=Dbn;
push16(Buf, Npts);  % Buf -> stack
qpop16(DBN);  % stack -> dama

