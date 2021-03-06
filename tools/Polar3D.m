% Convert Polar to Cartesian (3D)
%
% [radius,elevation,azimuth]=Polar3D([x,y,z])
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

function y=Polar3D(x)

X = x(:,1);
Y = x(:,2);
Z = x(:,3);

azimuth   = angle(X+1j*Y);
radius2D  = abs(X+1j*Y);
elevation = angle(1j*radius2D+Z); % 0 is pointing up. pi is pointing down. pi/2 points to horizon
radius    = abs(1j*radius2D+Z);

y = [radius,elevation,azimuth];
