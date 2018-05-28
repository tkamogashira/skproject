function Out=LinRampNPts(In,NPts)
%LinRampNPts -- Apply linear rise/fall ramps for specified number of points to the input signal
%
%In : Input vector
%NPts : Number of points for one ramp
%
%Usage: Out=LinRampNPts(In,NPts)
%By SF, 7/24/01

%Check if the ramp is not too long
if NPts*2>length(In)
   error('Too long ramp duration relative to the input signal!');
end

%Apply ramps
Out=In;
Out(1:NPts)=Out(1:NPts).*linspace(0,1,NPts);
Out((end-NPts+1):end)=Out((end-NPts+1):end).*linspace(1,0,NPts);


