function Val = CircuitInfo(dev, Prop, Val);
% private_circuitInfo - helper function for bookkeeping of properties of loaded circuits
%   Called by sys3loadCircuit (setter), sys3CircuitItems (getter),
%   and sys3dev (resetter).
%   Syntax:
%     CircuitInfo(Dev) returns all info on device Dev in struct
%     CircuitInfo(Dev, '-reset') clears properties of device Dev
%     CircuitInfo(Dev, 'Foo', Val) sets property Foo of device Dev to Val.
%     V = CircuitInfo(Dev, 'Foo') returns property Foo of dvice Dev.
%
%   Set multiple values using cell arrays for Prop & Val, or by passing
%   Prop/Val in a struct.
%
%   See also helper function private_CircuitItems
persistent Cinfo

if (nargin>2) && iscell(Prop) && iscell(Val), % recursive handling of multiple Prop/Val pairs
    for ii=1:length(Prop),
        private_CircuitInfo(dev, Prop{ii}, Val{ii});
    end
    return
end

if (nargin==2) && isstruct(Prop), % recursive handling of multiple Prop/Val pairs
    private_CircuitInfo(dev, fieldnames(Prop), struct2cell(Prop));
    return
end

%-----------simple calls from here----------
if nargin<1, % return all that is known
    Val = Cinfo;
    return;
end

if isempty(dev), dev = sys3defaultdev; end
[dev, Mess] = private_devicename(dev);
error(Mess);

if (nargin==1), % returns all info on Dev in struct
    if isempty(Cinfo), Val = [];
    else, Val = Cinfo.(dev);
    end
end

if nargin==2
    if isequal('-reset', Prop), % reset call
        Cinfo.(dev) = [];
    else,
        % get call
        Val = Cinfo.(dev).(Prop);
    end
end

if nargin>2, % set call
    Cinfo.(dev).Device = dev;
    Cinfo.(dev).(Prop) = Val;
end







