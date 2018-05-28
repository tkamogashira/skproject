function dvc = DVcomp(RR)
% DVcom - most recent result of DataView computation as a MatLab struct variable
persistent DVC
if nargin>0, % update
   DVC = RR;
end
dvc = DVC;
   