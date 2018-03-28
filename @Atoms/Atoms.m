% A group of atoms.
% Each atom is defined by:
%   normal:     3D vector perpendicular to atom surface. Length=res/2
%   surface:    3D coordinate of atom surface center
%   material:   instance of classdef Material
%   corner:     2 angles. Corner opening, and corner orientation
%   res:        Atom size (1D: res=corner length, 2D: res^2 = area,
%
%
% -------------------------------------------------------------------------
%     This is a part of the Qamcom Channel Model (QCM)
%     Copyright (C) 2017  Bj�rn Sihlbom, QAMCOM Research & Technology AB
%     mailto:bjorn.sihlbom@qamcom.se, http://www.qamcom.se, https://github.com/qamcom/QCM
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

classdef Atoms
    
    properties
        normal;
        surface;
        material;
        corner;
        res;
        velocity;
    end
    
    methods
        
        function a=Atoms(normal,surface,material,corner,res,velocity)
            if nargin
                a.normal   = normal;
                a.surface  = surface;
                a.material = material;
                a.corner   = corner;
                a.res      = res;
                a.velocity = velocity;
            end
        end
        
        function a=cat(a,b)
            a.normal   = [a.normal;  b.normal  ];
            a.surface  = [a.surface; b.surface ];
            a.material = [a.material;b.material];
            a.corner   = [a.corner;  b.corner  ];
            a.res      = [a.res;     b.res     ];
            a.velocity = [a.velocity;b.velocity];
        end
        
        Plot(a,forceColor);
        [x,y,z,c] = SurfacePatches(a);
        [x,y,z,c] = CornerPatches(a);
        y         = Prune(a,ind);
    end
end
