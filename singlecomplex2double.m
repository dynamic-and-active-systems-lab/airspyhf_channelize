function [doubleNum] = singlecomplex2double(singleComplex)
%singlecomplex2double Converts a undoes the result of the
%double2singlecomplex function.
%
%Thus function accepts a complex number with single precision and combines
%the real and imaginary parts and converts the result to a double precision
%number. The double2singlecomplex fuction Converts a double precision
%floating point number to a complex value single precision number,
%with the most significant bits and the least significant bits in the real
%and imaginary parts of the output, respectively. This function convers
%this result to the original double precision number.
%
%Not that these conversions are convienent for time stamping UDP messages
%that are set up for single precision complex data with timestamps that
%require double precision.
%
%
%INPUTS:
%   singleComplex   Matrix with MSBs of the double precision value being
%                   packed stored as a single precision real value and
%                   LSBs of input of the double precision value being
%                   stored as a single precision imaginary value.
%OUTPUTS:
%   doubleNum       Matrix of size of input with of double precision
%                   floating point numbers
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-01-20
%-------------------------------------------------------------------------

if ~isa(singleComplex,'single') || isreal(singleComplex)
    error('UAV-RT: Input must be single precision complex floating point.')
end

doubleNum = ones(size(singleComplex));

for i = 1:numel(singleComplex)
    topSingleOut     = real(singleComplex(i));
    botSingleOut     = imag(singleComplex(i));
    topVecOut        = typecast(topSingleOut,'uint8');
    botVecOut        = typecast(botSingleOut,'uint8');
    topHexVecOut     = dec2hex(topVecOut)';
    botHexVecOut     = dec2hex(botVecOut)';
    topHexStringOut  = topHexVecOut(:)';
    botHexStringOut  = botHexVecOut(:)';
    fullHexStringOut = [topHexStringOut, botHexStringOut];
    doubleNum(i)     = hex2num(fullHexStringOut);

end
end

