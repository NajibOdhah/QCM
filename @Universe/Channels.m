% Renders channel coefficients for given frequency bins and endpoints.
%
% [y,bbrx]=u.Channels(freqs,rain,x0,x1,bbtx)
% u is an handle to a Universe class (this class)
% freqs:    Vector of frequencies [Hz]
% rain:     Rain intensity [mm/h]
% x0:       Vector of endpoints (class PointOfView)
% x1:       Vector of endpoints (class PointOfView)
% bb:       BB signal transmitted over link. Default white
%
% x1 is optional.
% If excluded all combinations of endpoints in x0 are processed
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

function y=Channels(u,x0,x1,freqs,times,rain,bb)

if ~exist('bb','var') || isempty(bb), bb=ones(1,numel(freqs)); end
tic
CC=0;

% init y. Class?
y.N0 = numel(x0);
y.universe = u;
if ~isempty(x1)
%    y = ChannelResponse(freqs,rain,u,x0);
    y.N1 = numel(x1);
    y.N = y.N0*y.N1;
    fullH = 0;
else
%    y = ChannelResponse(freqs,rain,u,x0,x1);
    y.N1 = y.N0;
    y.N = (y.N0-1)*y.N0/2;
    fullH = 1;
    x1 = x0;
end
y.freqs = freqs;
y.times = times;

verbose = (numel(x0)*numel(x1)>1);

if verbose
    DispChannelProgress(y.N,0,0)
end

pp=0;

for endpoint0 = 1:y.N0
    
    pov0 = x0{endpoint0};
    
    for endpoint1 = 1:y.N1
        
        
        if endpoint1<endpoint0 && fullH
            
            % Reciprocal channel
            y.linkMap((endpoint1-1)*y.N0+endpoint0) = -y.linkMap((endpoint0-1)*y.N1+endpoint1);
            
        else
            
            pov1 = x1{endpoint1};
            
            
            
            % Save some particulars for convenience
            pp=pp+1;
            y.linkMap((endpoint1-1)*y.N0+endpoint0)=pp;
            y.endpoints(pp,:) = [endpoint0, endpoint1];
            
            % Get Channel
            [y.link{pp},cc] = u.Channel(pov0,pov1,freqs,times,rain,bb);
                
        end
        if verbose
            CC = CC+cc;
            DispChannelProgress(y.N,pp,cc);
        end
    end
    
end
if verbose
    fprintf('\nIn total %d Complex Channel Coefficients calculated.\n',CC)
end
y.toc = toc;



