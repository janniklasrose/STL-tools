function [facesCombined, verticesCombined] = stlCombineMeshes(meshes)
%STLCOMBINEMESHES concatenates multiple mesh face and vertex arrays.

facesCombined = NaN(3, sum([meshes.nFaces]));
verticesCombined = NaN(3, sum([meshes.nVertices]));

ptrF = uint32(0);
ptrV = uint32(0);
for iMesh = 1:numel(meshes)
  mesh = meshes(iMesh);
  facesT = uint32(mesh.FacesT);
  verticesT = mesh.VerticesT;

  facesCombined(:, ptrF + 1:ptrF + size(facesT, 2)) = facesT + ptrV;
  verticesCombined(:, ptrV + 1:ptrV + size(verticesT, 2)) = verticesT;
  ptrF = ptrF + size(facesT, 2);
  ptrV = ptrV + size(verticesT, 2);
end

facesCombined = facesCombined.';
verticesCombined = verticesCombined.';
