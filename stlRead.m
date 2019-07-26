function [v, f, n, name] = stlRead(fileName,legacy)
%STLREAD reads any STL file not depending on its format
%V are the vertices
%F are the faces
%N are the normals
%NAME is the name of the STL object (NOT the name of the STL file)
%LEGACY is a boolean that, if true, uses the legacy reader for binary files

if nargin < 2
  legacy = false();
end

% read content
format = stlGetFormat(fileName);
if strcmp(format,'ascii')
  [v,f,n,name] = stlReadAscii(fileName);
elseif strcmp(format,'binary')
  if legacy
    [v,f,n,name] = stlReadBinary(fileName);
  else
    [v,f,n,~,name] = stlReadBinary_fast(fileName);
  end
end

% slim the data (delete duplicated vertices)
[v,f]=stlSlimVerts(v,f);
