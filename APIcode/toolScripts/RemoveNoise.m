function RemoveNoise(filename, pcstream, ant, startPkt,lastPkt)
%PCA denoising for CSI

%filename:file of the raw CSI data
%pcstream:select the pcstream-th PCA component
%ant:antenna number([1,3])
%startPkt:startPkt packet
%lastPkt:lastPkt packet

%Author: Yuxiang Lin
%Date: 7_28_2017


csi_trace = read_bf_file(filename);
len = length(csi_trace);
if nargin == 1
    pcstream = 2;
    ant = 1;
    startPkt = 1;
    lastPkt = len;
elseif nargin == 2
    ant = 1;
    startPkt = 1;
    lastPkt = len;
elseif nargin == 3
    startPkt = 1;
    lastPkt = len;
elseif nargin == 4 || nargin > 5
    error('Requires 1,2,3 or 5 input arguments.');
end

color_table = ['b','g','r','c','m','y','k','w'];
amplitudeArray = zeros(30,lastPkt-startPkt);

for i = 1:lastPkt-startPkt
    csi_entry = csi_trace{i+startPkt};
    csi = get_scaled_csi(csi_entry);
    for subc = 1:30
        amplitudeArray(subc,i) = db(abs(csi(1,ant,subc)));
    end
end
%save('amplitude.mat','amplitudeArray');
%cov_ingredients=cov(amplitudeArray)
amplitudeArray=amplitudeArray';
[coeff,score,latent]=princomp(amplitudeArray);
size(amplitudeArray)
size(score)
size(coeff)
len2=length(score)
%pca3=zeros(30,30);
%pca3(:,pcstream)=coeff(:,pcstream);
score2=zeros(len2,30);
score2(:,pcstream:30)=score(:,pcstream:30);
%result=(score2)';
%result=score';
result=(score2*coeff)';

for subc = 1:30
    plot(result(subc,:),color_table(mod(subc,8)+1));
    hold on;
end
axis([1 lastPkt-startPkt -15 15]);
xlabel('Packets Number');
ylabel('Amplitude');
end