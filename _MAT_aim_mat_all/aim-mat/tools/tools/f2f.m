% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% Maintained by Tom Walters (tcw24@cam.ac.uk), written by Stefan Bleeck (stefan@bleeck.de)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function res=f2f(value,from1,to1,from2,to2,logstate)
% usage:res=f2f(from1,to1,value1,from2,to2,is_log)
% translates the value from the system from1 to1 to the system from2 to2
% either logarithmic or not

if nargin < 6
    logstate='linlin';
end


if to1==from1
    res=from1;
    return;
end


switch logstate
    case 'loglin'
        m=(to2-from2)/(log(to1)-log(from1));
        c= from2-log(from1)*m;
        res= m*log(value)+c;
    case 'linlog'
        m=(log(to2)-log(from2))/(to1-from1);
        c= log(from2)-m*from1;
        res=exp(m*value+c);
        
%         b=log(min)+gene_val*(log(max)-log(min));
%     	res=exp(b);
    case 'linlin'
        m=(to2-from2)/(to1-from1);
        c= from2-m*from1;
        res=m*value+c;
end