function hmess = MessageHandle;
% returns most recent message handle
global UImessStack
cleanUImessstack; % remove dead handles
if isempty(UImessStack),
   hmess = [];
else,
   hmess = UImessStack(end);
end

