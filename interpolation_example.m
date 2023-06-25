x = 0:pi/4:2*pi; 
v = sin(x)+ cos(x);

xq = 0:pi/16:2*pi;

figure('Name', 'Interpolation example')

subplot(131)
plot(x,v,'b*');
title('Original sequence');

subplot(132)
vq1 = interp1(x,v,xq);
plot(x,v,'b*',xq,vq1,':.');
xlim([0 2*pi]);
title('Linear Interpolation');

subplot(133)
vq1 = interp1(x,v,xq,'cubic');
plot(x,v,'b*',xq,vq1,':.');
xlim([0 2*pi]);
title('Cubic Interpolation');