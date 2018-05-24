function cf = getCFList(L)

% getCFList(L)
% Returns the cf for the fiber in the list CorFncs in genwfplot
%
% TF 07/09/2005

filename = L(1).ds1.filename;
if ~isnan(L(1).ds1.iseqp), ds = L(1).ds1.iseqp;
else, ds = L(1).ds1.iseqn;
end

fnr=getFnr({filename}, ds);
g=getCF4Cell(filename, fnr);
cf=g.thr.cf;