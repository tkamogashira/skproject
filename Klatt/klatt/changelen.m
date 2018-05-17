function h = changelen(h, dur)

fn = fieldnames(h);
for i = 1:length(fn)
    if isstruct(getfield(h, fn{i}))
	eval(sprintf('h.%s.xdata(end) = dur;', fn{i}));
    end
end
