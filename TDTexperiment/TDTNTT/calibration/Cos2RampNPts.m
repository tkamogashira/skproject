function Out=Cos2RampNPts(In,NPts)
%Cos2RampNPts -- Apply raised-cosine rise/fall ramps for specified number of points to the input signal
%
%In : Input vector
%NPts : Number of points for one ramp
%
%Usage: Out=Cos2RampNPts(In,NPts)
%By SF, 7/24/01

%Check if the ramp is not too long
if NPts*2>length(In)
   error('Too long ramp duration relative to the input signal!');
end

%Apply ramps
Out=In;
Ramp=cos((1:NPts)/NPts*pi/2).^2;
Out(1:NPts)=Out(1:NPts).*(1-Ramp);
Out((end-NPts+1):end)=Out((end-NPts+1):end).*Ramp;


