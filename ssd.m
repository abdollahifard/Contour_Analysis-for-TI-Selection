function z = ssd(I, Pattern, mask)
% mask determines location of valid values
% Pattern should not be nanor inf  in invalid points,

a2 = filter2(mask, I.^2, 'valid');
b2 = sum(sum((Pattern.^2).*mask));
ab = filter2(Pattern.*mask, I, 'valid').*2;
z = sqrt((a2 - ab + b2)/sum(sum(mask)));

