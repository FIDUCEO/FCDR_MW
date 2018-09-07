

%% build vector for correlation coefficients (structured effects)
% The correlation should decrease over 7 scan lines to zero because of the
% 7-scan line average. In D2.2.a, Emma Woolliams describes how the
% correlation drops off for this case of a weighted rolling average. The
% resulting shape is "Gaussian-like". So, it is suggested to approximate
% this shape with a Gaussian of width sigma=m/sqrt(3), with m=3 (from +-3 scan
% lines around specific scan line), truncated for a separation of scan
% lines of delta l>6.


sigma=3/sqrt(3);

x = [-6:1:6];
gaussian= normpdf(x,0,sigma)/max(normpdf(x,0,sigma));

corr_vector=gaussian(7:end);
