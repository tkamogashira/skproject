function sys3setPA5(att, att2);  
% sys3setPA5 - set attenuator value(s) of PA5(s)
%  
%   sys3setPA5(x), where x is a scalar, sets both attenuators to x dB.  
%   sys3setPA5([x1 x2]) or set(x1,x2) sets PA5_1 and PA5_2 to x1 and x2 dB, resp.  
%   A NaN value for x1 or x2 results in the current value of that channel  
%   being left unchanged.  
%  
%   See also SYS3DEV.  
  
% get actxcontrols - create if needed  
u = sys3dev;  
  
if nargin>1, att = [att att2]; end  
if length(att)==1,  
    att = [att att];  
end  
  
if any(att>120) | any(att<0),
   error(['Attenuator value(s) out of range for PA5 attenuator.']);
end

if ~isnan(att(1)), invoke(u.PA5_1,'SetAtten',att(1)); end;  
if ~isnan(att(2)), invoke(u.PA5_2,'SetAtten',att(2)); end;  
  


