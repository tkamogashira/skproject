function Mess = sys3PA5(att, att2);  
% sys3PA5 - set attenuator value(s) of PA5(s) 
%  
%   sys3PA5(x), where x is a scalar, sets both attenuators to x dB.  
%   sys3PA5([x1 x2]) or set(x1,x2) sets PA5_1 and PA5_2 to x1 and x2 dB, resp.  
%   A NaN value for x1 or x2 results in the current value of that channel  
%   being left unchanged. Thus setPA5([nan 31]) only sets attenuator #2.
%   An error occurs when a requested attenuation value is outsides the 
%   0..120-dB range.
%
%   sys3PA5([]) does nothing. In particular, it does not cause an error if
%   no attenuators are connected. This is useful to restore the settings 
%   captured by sys3PA5get, which returns [] in the absence of PA5s.
%  
%   Mess = sys3PA5(..) suppresses the out-of-range error and returns the
%   error message in stringg Mess instead. Default Mess == ''.
%
%   See also sys3dev, sys3PA5get.
  
if nargin==1 && isempty(att),
    return; % do nothing. 
end

if nargin>1, att = [att att2]; end  
if length(att)==1,  
    att = [att att];  
end  

Mess = '';
if any(~betwixt(denan(att), [-0.0001 120.0001])),
    Mess = 'Attenuation value out of range.';
    if nargout<1, error(Mess); end
    if ~isempty(Mess), return; end
end

% make sure devices have been initialized, connected, etc
sys3dev;
if ~isnan(att(1)), invoke(sys3dev('PA5_1'),'SetAtten',att(1)); end;  
if ~isnan(att(2)), invoke(sys3dev('PA5_2'),'SetAtten',att(2)); end;  
if nargout<1, clear Mess; end; % only return Mess when requested
  
  
