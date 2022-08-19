function [singleComplex] = double2singlecomplex(doubleNum)
%double2singlecomplex Converts a double precision floating point number to
%a complex value single precision number, with the most significant bits
%and the least significant bits in the real and imaginary parts of the
%output, respectively.
%
%INPUTS:
%   doubleNum       Matrix of double precision floating point numbers
%OUTPUTS:
%   singleComplex   Matrix of size of input with MSBs of input stored as a
%                   single precision real value and with LSBs of input 
%                   stored as a single precision imaginary value. 
%
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-01-20
%-------------------------------------------------------------------------

if ~isa(doubleNum,'double') || ~isreal(doubleNum)
    error('UAV-RT: Input must be double precision real value floating point.')
end


singleComplex = complex(single(ones(size(doubleNum))));

for i = 1:numel(doubleNum)
    fullHexStringIn  = num2hex(doubleNum(i));
    topHexStringIn   = fullHexStringIn(1:8);
    botHexStringIn   = fullHexStringIn(9:16);
    topVecIn         = uint8(sscanf(topHexStringIn,'%2x'));
    botVecIn         = uint8(sscanf(botHexStringIn,'%2x'));
    topSingleIn      = typecast(topVecIn,'single');
    botSingleIn      = typecast(botVecIn,'single');
    singleComplex(i) = complex(topSingleIn, botSingleIn);
end
end

