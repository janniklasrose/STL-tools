function vnew = stlRotate(v, axis, theta)
%STLROTATE rotates a vertex list around a Cartesian axis.
% V is an n-by-3 vertex array.
% AXIS is one of 'x', 'y', or 'z'.
% THETA is expressed in degrees.

cosTh = cosd(theta);
sinTh = sind(theta);
switch axis
  case 'x'
    rTheta = [1, 0, 0; 0, cosTh, -sinTh; 0, sinTh, cosTh];
  case 'y'
    rTheta = [cosTh, 0, sinTh; 0, 1, 0; -sinTh, 0, cosTh];
  case 'z'
    rTheta = [cosTh, -sinTh, 0; sinTh, cosTh, 0; 0, 0, 1];
  otherwise
    error('axis must be ''x'', ''y'', or ''z''.');
end

vnew = transpose(rTheta * transpose(v));
