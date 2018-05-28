function h = UIhandle(h);
if ischar(h),
   h = getfield(stimmenuHandles, h);
end