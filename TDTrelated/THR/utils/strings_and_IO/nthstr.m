function ns=nthstr(n);
%  NTHSTR - strings '1st', '2nd', etc
%    NthStr(1) returns '1st', etc

if n==1, ns = '1st';
elseif n==2, ns = '2nd';
elseif n==3, ns = '3rd';
else ns = [num2str(n) 'th'];
end   
   