% Complex Attenuation and Phase coeff vs rays distance and frequencies
% 
% y = DistanceCoeff(freqs,radius)
% freqs:    Frequency vector [Hz]
% radius:   Ray distance [m]
% y:        Ray (amplitude) coeff. Matrix y(radius-index,freq-index)
%
% Source
% https://en.wikipedia.org/wiki/Free-space_path_loss
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

function y = DistanceCoeff(freqs,radius)

% Phase & pathloss
pirfc     = pi*radius*(freqs/sys.c);
phase     = -2*pirfc;
amplitude = min(1,1./(4*pirfc));

y = single(amplitude.*exp(1j*phase));