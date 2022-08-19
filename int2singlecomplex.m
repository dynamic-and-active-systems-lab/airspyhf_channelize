function [singleComplex] = int2singlecomplex(intIn)
%int2singlecomplex Converts an integer value to a complex single precision
%number with a portion of the integer digits in the real and imaginary
%parts of the output. The input integer is split at the 7th digit. The top
%digits are then held in the real part of the output, while the lower 7
%digits are held in the imaginary part of the output. 
%
%A single precision number has a maximum integer
%values of flintmax('single') = 16777216. To avoid overrunning the
%available digits, the input integer is split at digit 7.
%
%The max value for each output part would be:  16777216 + 1i * 16777216
%To avoid overflow, the complex part 
%containing the lower digits only use          16777216 + 1i *  xxxxxxx
%the first 7 digits available
%
%Based on this standard, the maximum value that can be transmitted is 
%   167772169999999 = 1.6777e14;
%
%INPUTS:
%   intIN           Matrix of integer values. If decimal values are
%                   transmitted, they will be rounded by this program.
%                   Maximum input value is 167772169999999. Inputs
%                   exceedign this value will result in an error. 
%OUTPUTS:
%   singleComplex   Matrix of size of input with first 7 digits of input 
%                   held in the imaginary part and the remaining upper 
%                   digits held in the real part. 
%
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-08-19
%-------------------------------------------------------------------------

if intIn > 167772169999999
    error('UAV-RT: Input must be an integer less than 167,772,169,999,999.')
end

intIn = round(intIn);

digitSplit       = 7;
topDigits        = floor(intIn*10^-digitSplit);
botDigits        = intIn - topDigits*10^digitSplit;
topDigitsSingle  = single(topDigits);
botDigitsSingle  = single(botDigits);
singleComplex    = complex(topDigitsSingle, botDigitsSingle);

end

