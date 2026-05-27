function [v, f, n, name] = stlReadBinary(fileName)
%STLREADBINARY reads a STL file written in BINARY format
%V are the vertices
%F are the faces
%N are the normals
%NAME is the name of the STL object (NOT the name of the STL file)

%=======================
% STL binary file format
%=======================
% Binary STL files have an 84 byte header followed by 50-byte records, each
% describing a single facet of the mesh.  Technically each facet could be
% any 2D shape, but that would screw up the 50-byte-per-facet structure, so
% in practice only triangular facets are used.  The present code ONLY works
% for meshes composed of triangular facets.
%
% HEADER:
% 80 bytes:  Header text
% 4 bytes:   (int) The number of facets in the STL mesh
%
% DATA:
% 4 bytes:  (float) normal x
% 4 bytes:  (float) normal y
% 4 bytes:  (float) normal z
% 4 bytes:  (float) vertex1 x
% 4 bytes:  (float) vertex1 y
% 4 bytes:  (float) vertex1 z
% 4 bytes:  (float) vertex2 x
% 4 bytes:  (float) vertex2 y
% 4 bytes:  (float) vertex2 z
% 4 bytes:  (float) vertex3 x
% 4 bytes:  (float) vertex3 y
% 4 bytes:  (float) vertex3 z
% 2 bytes:  Padding to make the data for each facet 50-bytes in length
%   ...and repeat for next facet... 

fid = fopen(fileName);
header = fread(fid,80,'int8'); % reading header's 80 bytes
name = deblank(native2unicode(header,'ascii')');
if isempty(name)
    name = 'Unnamed Object'; % no object name in binary files!
end
nfaces = fread(fid,1,'int32');  % reading the number of facets in the stl file (next 4 byters)
% reserve memory for vectors (increase the processing speed)
n = zeros(3, nfaces);
v = zeros(3, 3, nfaces);
f = zeros(3, nfaces);
for i = 1 : nfaces % read the data for each facet
    tmp = fread(fid,3*4,'float'); % read coordinates
    n(:,i)   = tmp(1:3); % x,y,z components of the facet's normal vector
    v(:,1,i) = tmp(4:6); % x,y,z coordinates of vertex 1
    v(:,2,i) = tmp(7:9); % x,y,z coordinates of vertex 2
    v(:,3,i) = tmp(10:12); % x,y,z coordinates of vertex 3
    offset = 3*(i-1);
    f(:,i) = offset + (1:3); % face
    fread(fid,1,'int16'); % Move to the start of the next facet (2 bytes of padding)
end
fclose(fid);

f = transpose(f);
n = transpose(n);
v = transpose(reshape(v, 3, []));
