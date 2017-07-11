function y = IsSamePoints(pointOne, pointTwo, pixelSize)
% input@pointX[x0,y0,dx0,dy0]

if pixelSize <= 0
    return;
end
t1 = pixelSize.*(pointTwo(1:2) - pointOne(1:2))./pointOne(3:4);
t1 = t1.^2;
t2 = sum(t1);%(x2 - x1)^2/(dx1*pixeSize)^2 + (y2 - y1)^2/(dy1*pixeSize)^2
d1 = pixelSize.*(pointOne(1:2) - pointTwo(1:2))./pointTwo(3:4);
d2 = sum(d1);
if (t2 <= 1)&&(d2 <= 1)
    y = 1;
else
    y = 0;
end
