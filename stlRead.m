function [v, f, n, name] = stlRead(fileName,legacy,varargin)
%STLREAD reads any STL file not depending on its format
%V are the vertices
%F are the faces
%N are the normals
%NAME is the name of the STL object (NOT the name of the STL file)
%LEGACY is a boolean that, if true, uses the legacy reader for binary files
% Optional name-value pairs:
%   faceType - integer type used for face indices
%   normType - numeric type used for normals
%   vertType - numeric type used for vertices

if nargin < 2
  legacy = false();
elseif ischar(legacy) || (isstring(legacy) && isscalar(legacy))
  varargin = [{legacy}, varargin];
  legacy = false();
end

p = inputParser();
p.addParameter('faceType', 'uint32', @validateIndexType);
p.addParameter('normType', 'single', @validateCoordType);
p.addParameter('vertType', 'single', @validateCoordType);
p.parse(varargin{:});
opt = p.Results;

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

if size(v, 1) > intmax(opt.faceType)
  error('stlRead:FaceTypeOverflow', ...
    'faceType %s cannot represent %d vertices.', char(opt.faceType), size(v, 1));
end

v = cast(v, opt.vertType);
n = cast(n, opt.normType);
f = cast(f, opt.faceType);

end

function validateNumericType(s)

validateattributes(s, {'char', 'string'}, {'scalartext'});
try
  zeros(s);
catch me
  error(me.message);
end

end

function validateIndexType(s)

validateNumericType(s);

c = char(s);
assert(strncmp(c,'int',3) || strncmp(c,'uint',4), 'faceType must be an integer type');

end

function validateCoordType(s)

validateNumericType(s);

end
