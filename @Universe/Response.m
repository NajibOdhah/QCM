% Plots channel response (FD and TD) of selected links
%
% Response(u,pov0,pov1,freqs,rain)
% x is an instance of a ChannelResponse class (this class) generated by the Universe.Channel method
% links are indece into x.linkMap. Indexed the same way as POV vectors x0 and x1 passed to Universe.Channel 
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

function [Hf,Fbins,Ht,Tbins,Rbins,Pt,Pf]=Response(u,povs0,povs1,freqs,rain)

D  = sys.maxRadius*2/sys.c; % Max delay spread [sec] approx as twice emax ray trace distance.
d  = sys.largeScaleResolution/sys.c;% Min delay spread [sec].
Bc = 1/D; % Coherence bandwith https://en.wikipedia.org/wiki/Coherence_bandwidth
Bt = 1/d; % Total BW
Nf = round(Bt/Bc/2);
  
% Calculate channel densely enough (Twice Nyquist, Samples at Bc/4)
freqs = max(Nf*Bc,mean(freqs))+(-Nf:Nf)*Bc;

x = u.Channels(povs0,povs1,freqs,0,rain);

clf;
Hf=[]; tags={}; 
for ii=1:x.N
    tmp = u.Channel(povs0{1},povs1{ii},freqs,0,rain);
    [ne0,ne1,nf]=size(tmp.Hf);
    Hf(1:ne0,1:ne1,1:nf,ii)=tmp.Hf;
    tags{end+1} = tmp.tag;
end
Hf = permute(Hf,[3,1,2,4]);
Nf = size(Hf,1);
Nfft = 4*2^ceil(log2(Nf));
SS = size(Hf);
SS(1)=Nfft;
scind = mod((0:Nf-1)-round(Nf/2),Nfft)+1;
Ht = zeros(SS);
rc = cos((-(Nf-1)/2:(Nf-1)/2)/Nf*pi).^2';
Ht(scind,:) = Hf(:,:).*repmat(rc,1,prod(SS(2:end)));
Ht = ifft(Ht)*sqrt(Nf);
Pf = 20*log10(permute(rms(rms(Hf,2),3),[1,4,2,3]));
Pt = 20*log10(permute(rms(rms(Ht,2),3),[1,4,2,3]));
Ts = 1/mean(diff(sort(x.freqs)));

Fbins = x.freqs;
Tbins = (0:Nfft-1)/Nfft*Ts;
Rbins = sys.c*Tbins;

subplot(1,2,1); plot(Fbins/1e9, Pf,'LineWidth',2); title('Frequency Response'); ylabel('dB'); xlabel('Frequency [GHz]'); grid on; legend(tags);
subplot(1,2,2); plot(Rbins,     Pt,'LineWidth',2); title('Temporal Response');  ylabel('dB'); xlabel('Distance [m]');    grid on; legend(tags);
maxS = sys.maxRadius;%min(sys.maxRadius,Rbins(find(max(Pt,[],2)>max(Pt(:))-sys.raySelThreshold,1,'last')));
axis([0 maxS*2 min(0,min(max(Pt))-sys.raySelThreshold-10) max(0,max(Pt(:)))]);

% R =4;
% Nv = 8;
% Nh = 8;
% [Nf,N0,N1,P0,P1,Nlink] = size(Ht);
% Hst0 = reshape(Ht,[Nf,Nv,Nh,N1,P0,P1,Nlink]);
% Hst0 = fftshift(fft(fftshift(fft(Hst0,Nv*R,2),2),Nh*R,3),3);
% Hst1 = reshape(Ht,[Nf,N0,Nv,Nh,P0,P1,Nlink]);
% Hst1 = fftshift(fft(fftshift(fft(Hst1,Nv*R,3),3),Nh*R,4),4);
%
% selLink = 1;
% figure
% Pst0 = squeeze(rms(rms(rms(Hst0,4),5),6));
% xx = 20*log10(squeeze(rms(Pst0(:,:,:,selLink),2)))';
% subplot(1,2,1); imagesc(xx,max(xx(:))-[60 0])
% title('Response vs angle and delay on endpoint 0 (from endpoint 1)');
% Pst1 = squeeze(rms(rms(rms(Hst1,2),5),6));
% xx = 20*log10(squeeze(rms(Pst1(:,:,:,selLink),3)))';
% subplot(1,2,2); imagesc(xx,max(xx(:))-[60 0])
% title('Response vs angle and delay on endpoint 1 (from endpoint 0)');

