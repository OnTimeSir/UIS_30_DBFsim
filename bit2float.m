function y = bit2float(x, float_bits)
FLOAT_2N15 = 0.000030517578125;	%2^-15
NUM_AND_15BIT = 32767;	% 2^15-1
y = single(bitshift(x,-float_bits))+ FLOAT_2N15*single(bitand(x,NUM_AND_15BIT));