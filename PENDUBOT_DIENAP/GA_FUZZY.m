clc;
clear all
rand('state',sum(100*clock));
max_generation=200;			% c� 250 l?n ch?y trong qu� tr�nh
max_stall_generation=20;		% 50 th? h? gi?ng nhau th� d?ng
epsilon=0.0001;			% J chu?n
pop_size=35;				% s? l??ng c� th? cha m? trong qu?n th?
npar = 5;				% c� 5 nhi?m s?c th? trong 1 c� th?
range=[ 0 0 0 0 0;...
100 100 100 100 100];		% gi� tr? K1 K2 K3 K4 K5 n?m trong kho?ng 0-100
dec=[2 2 2 2 2];			% c� 2 ch? s? nguy�n
sig=[5 5 5 5 5];			% c� 5 ch? s? th?p ph�n
cross_prob = 0.95;			% x�c xu?t lai gh�p
mutate_prob = 0.05;			% x�c xu?t ??t bi?n
elitism = 1;				% lu�n gi? l?i gi� tr? t?t nh?t trong khi lai t?o
rho=0.02;				% tr?ng s? quy?t ??nh c�i n�o quan tr?ng v?i J h?n
par=Init(pop_size,npar,range);	% khai t?o 35 c� th? cha me ??u ti�n
Terminal=0;				% kh?i ??ng c�c gi� tr? ??u ti�n tr??c khi ch?y GA
generation = 0;			% kh?i ??ng c�c gi� tr? ??u ti�n tr??c khi ch?y GA
stall_generation=0;			% kh?i ??ng c�c gi� tr? ??u ti�n tr??c khi ch?y GA
for pop_index=1:pop_size,
K1=par(pop_index,1)-100;
K2=par(pop_index,2)-100;
K3=par(pop_index,3)-100;
K4=par(pop_index,4)-100;
K5=par(pop_index,5)-100;
sim('FINAL_DKTM.slx');		% b?t ??u m� ph?ng
J=(e'*e)+rho*(u'*u);
fitness(pop_index)=1/(J+eps); % t�m c?c ti?u h�m th�ch nghi
end;
[bestfit0,bestchrom]=max(fitness);
K10=par(bestchrom,1)-100;		%c�c c� th? cha m? ??u ti�n
K20=par(bestchrom,2)-100;		%c�c c� th? cha m? ??u ti�n
K30=par(bestchrom,3)-100;		%c�c c� th? cha m? ??u ti�n
K40=par(bestchrom,4)-100;		%c�c c� th? cha m? ??u ti�n
K50=par(bestchrom,5)-100;		%c�c c� th? cha m? ??u ti�n
J0=1/bestfit0-0.001
while ~Terminal
generation = generation+1;
disp(['generation #' num2str(generation) ' of maximum ' num2str(max_generation)]);
pop=Encode_Decimal_Unsigned(par,sig,dec); % m� h�a th?p ph�n (NST c?a c�c cha m?)
parent=Select_Linear_Ranking(pop,fitness,0.2,elitism,bestchrom); 
child=Cross_Twopoint(parent,cross_prob,elitism,bestchrom);% lai gh�p 2 ?i?m
pop=Mutate_Uniform(child,mutate_prob,elitism,bestchrom);% ??t bi?n theo d?ng ph�n b? ??u
par=Decode_Decimal_Unsigned(pop,sig,dec);% gi?i m� k?t qu? v? l?i NST
for pop_index=1:pop_size,		% ?�nh gi� l?i ?? th�ch nghi c�c c� th? sau ti?n h�a
 K1=par(pop_index,1)-100;		% quy ??i gi� tr? NST v? K1
 K2=par(pop_index,2)-100;		% quy ??i gi� tr? NST v? K2
 K3=par(pop_index,3)-100;		% quy ??i gi� tr? NST v? K3
 K4=par(pop_index,4)-100;		% quy ??i gi� tr? NST v? K4
 K5=par(pop_index,5)-100;		% quy ??i gi� tr? NST v? K5
 sim('FINAL_DKTM.slx');		% ti?n h�nh ch?y m� ph?ng ?? ki?m tra
 J=(e'*e)+rho*(u'*u);
 fitness(pop_index)=1/(J+eps);
end;
[bestfit(generation),bestchrom]=max(fitness);
if generation == max_generation	% ?i?u ki?n d?ng
Terminal = 1; 
elseif generation>1,
if abs(bestfit(generation)-bestfit(generation-1))<epsilon,
stall_generation=stall_generation+1;
if stall_generation == max_stall_generation, Terminal = 1;end 
else
stall_generation=0;
end;
end;
end
plot(1./bestfit)				% v? ?? th? h�m th�ch nghi
K10
K20
K30
K40
K50
J0
K1=par(bestchrom,1)			% hi?n th? NST K1 
K2=par(bestchrom,2)			% hi?n th? NST K2 
K3=par(bestchrom,3)			% hi?n th? NST K3 
K4=par(bestchrom,4)			% hi?n th? NST K4 
K5=par(bestchrom,5)			% hi?n th? NST K5 
J=1/bestfit(end)			% h�m ti�u chu?n t??ng ?ng v?i c� th? con t?t nh?t n�y
sim('FINAL_DKTM.slx');		%tien h�nh m� ph?ng l?i 
