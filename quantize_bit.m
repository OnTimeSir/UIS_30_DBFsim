function y = quantize_bit(x, int_bits, float_bits )
% quantize the input number
%   int_bits -  the bit count of integer part
%   float_bits -  the bit count of float part 

% integer part
xi = floor(x);
xi = bitand(xi,2^int_bits-1);
% float part
xf = x - floor(x);
xf = floor(xf*2^float_bits)/(2^float_bits);
y = xi+xf;
end

