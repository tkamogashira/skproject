function methodizing
% Methodizing a function Func means making Func a method for Foo objects,
% even if it does not really need a Foo input. This is accomplished by 
% making the first function argument of Func a dummy Foo object. 
%
% Methodizing helps you organizing your code. For instance, if you want to 
% write a LOAD version that loads Foo objects from disk, then it is 
% natural to do write an overloaded Foo/LOAD. However, for a any function
% to be a Foo method, it must take a Foo argument. In the case of LOAD
% there is no obvious role for a Foo input argument. The solution is to
% provide LOAD with a dummy Foo argument, and call it like
%
%        load(Foo(), Filename, ...)
%
% Here Foo() is a call to the Foo constructor, which returns a void Foo
% object with all empty fields.
%
% See also transfer/LOAD.
