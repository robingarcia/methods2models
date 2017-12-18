function [xSol] = model_toettcher2008matlab(tF)
%% Modified final model of the cell cycle from Toettcher et. al. 2008

% This file simulates the final model that has been optimized to data of
% p53-/- and wild-type HCT116 cells, along with prior experimental results.



%% 1 - Set initial conditions and parameters

% initial conditions
ic = [
           0.10571352107562
           0.38312623418874
           0.48276208546527
           0.12059080828035
           0.05298624194329
           0.27622795992648
           0.72377204007352
           0.10800000246523
                          0
                          0
           0.82314432446375
           0.23039787827759
           0.86550355241630
           0.13449644758370
           0.12853421194054
           0.03171918381790
           0.00364798277897
           0.99635201722103
           0.29154163033354
           0.84525873847663
           0.69366395362820
           0.30633604637180
           0.48022736534955
           0.51977263465045
           0.13102942915972
           0.86897057084029
           0.00000000000105
           0.00000000000486
                          0
                          0
           0.00000000000112
    ];

% parameters
p = [
        0.02672911
        0.072883037
        0.012540723
        1.10533545
        0.983121087
        0.483202584
        38.8208575
        0.912303563
        0
        0.944400939
        4.289624695
        0.695561858
        0.607465699
        0.142911531
        0.355649607
        0.090794894
        0.060359562
        0.111805939
        0.070843874
        0.010780961
        1.315282704
        0.28020432
        0
        0
        0.458698428
        1.531146072
        0.022280272
        3.982302772
        0.709909666
        0.62139691
        0.241342161
        0.536479181
        0
        0.34692239
        0.25521286
        1.760195329
        0
        19.44713965
        0.861201703
        1.275055202
        0
        0.920234679
        3.615269202
        3.783525377
        0
        3.756752896
        0
        68.30418128
        68.32166373
        68.2779962
        87.9836684
        88.00647171
        0.516847272
        0.569643036
        0.01256464
        0.039597061
        0
        0.421152297
        0.998560911
        0.871954919
        0.225215586
        0.830418187
        0.716591306
        0.014171958
        0.009191891
        0.489532717
        3.226983145
        0
        0.405088108
        0.721551937
        0
        0.277759108
        0.121344291
        0.05814222
        0.186511774
        0
        0
        7.819855222
        0.298501874
        0.072401724
        0
        0.823676164
        1.477007696
        0
        0.368601966
        0.373902258
        0.2
        1.012708402
        0.005895952
        0.138980788
        38.74276923
        38.7323958
        0.799987678
        0.659667827
        0.235922751
        0.207532261
        0.342914323
        0.42023601
        77.6484404
        0.197189547
        0.002848167
        0.040692649
        0.016580212
        0.027567383
        0.018644672
        0.008385074
        0.142773874
];

%% 2 - Initialize inputs

% *************************************************************************
% In this section, the user can initialize any of the six arrest
% mechanisms defined in the text. In addition, the mitogen stimulus, cyclin
% knockout experiments, and cycloheximide treatment conditions can be
% varied.

% Use the arrest vector to choose a combination of arrest mechanisms with
% which to implement cell cycle arrest.
%
% Make sure to set p53_basal to the appropriate value (0.75 for wild-type,
% 0 for p53-/- cells), when running the corresponding simulation.
% *************************************************************************

% Mechanism I + II + III (wild-type cells)
arrest = [1 1 1];
% Mechanism IIa (p53-/- cells)
% arrest = [0 1 0 0 0 0];

% *************************************************************************
% This input applies p534np input from 4 h after the time of damage, and a
% transient p53-independent arrest that is on from the time of damage until
% a time of recovery.
% *************************************************************************
t_d = 10;
t_r = 50;

u = @(t) [1.8               % M
          0                 % p534np (phosphorylated p53 tetramers)
          0                 % Chk2p  (phosphorylated Chk2)
          0                 % Dko
          0                 % Eko
          0                 % CHX
          0.75              % p53_basal (basal activity of p53)
          arrest(1)         % arrest_I
          arrest(2)         % arrest_II
          arrest(3)         % arrest_III
          ];

%% 3 - Run the model
% *************************************************************************
% In this section, the model is simulated with the input defined above, for
% an amount of time tF.
% *************************************************************************


tic
tF = 0:2000;    % the final timepoint of simulation
xSol = ode15s(@final_model_eqns, tF, ic, odeset('Jacobian', @final_model_jacobian), p, u);
toc




%% 4 - Plot the resulting trajectory

% *************************************************************************
% This section plots a few key output species. This approach assumes output
% species of interest are linear combinations of the state variables being
% integrated, and uses the matrix 'c' to define these linear combinations.
% *************************************************************************

% c - a matrix defining some outputs for plotting
c = zeros(4, 31);
c(1,[3 4 9 10 30]) = 1;    % CycBT
c(2,[2 15 29]) = 1;        % CycAT
c(3,[5 16 31]) = 1;        % CycET
c(4,12) = 1;               % Cdc20A
% c(5,5) = 1;               % CycE;

figure(2)
plot(xSol.x, c*xSol.y, 'LineWidth', 2);
%set(gca, 'YLim', [0.03 0.12])
% legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
title('MATLAB cell cycle model')

%findpeaks(c*xSol.y(1,:));
end






function [dxdt] = final_model_eqns(t, x, p, u)
% 
% % Inputs (as described in Supplementary Table 1)
% % 1     -   mitogen levels
% % 2,3   -   DNA damage (modeled by p53 and chk2p activation)
% % 4,5   -   cyclin D and E knockouts
% % 6     -   cycloheximide treatment
% % 7     -   p53 basal activation (0.75 for wild-type cells, 0 for p53-/- cells)
% % 8-10  -   arrest mechanisms I-III

u = u(t);
[M, p534np, chk2p, Dko, Eko, CHX, p53_basal, arrest_I, arrest_II, arrest_III] = deal_args(u);

% All model species. Time derivatives are calculated for species in the order listed here.
[CycD, CycA, CycB, pB, CycE, APC, APCP, CKI, BCKI, pBCKI, Cdc20i, Cdc20A, Cdh1, Cdh1i, TriA, TriE, Wee1, Wee1i, ...
 Cdc25, Cdc25i, TFB, TFBi, TFE, TFEi, TFI, TFIi, p21, TriD21, TriA21, TriB21, TriE21] = deal_args(x);

% % All model parameters.
[kse_p, kse_pp, kde_p, kdea_pp, kdeb_pp, kdee_pp, kasse, kdisse, katf_p, katfa_pp, katfd_pp, katfe_pp, kitf_p, ...
 kitfa_pp, kitfb_pp, Jatf, Jitf, ksb_p, ksb_pp, kdb_p, kdbh_pp, kdbc_pp, kassb, kdissb, kwee_p, kwee_pp, k25_p, ...
 k25_pp, kafb, kifb, Jafb, Jifb, ksa_p, ksa_pp, kda_p, kda_pp, kda_ppp, kassa, kdissa, ksi_p, ksi_pp, kdi_p, kdia_pp, ...
 kdib_pp, kdid_pp, kdie_pp, k14di, kafi, kifi_p, kifib_pp, Jafi, Jifi, kaie, kiie, Jaie, Jiie, ks20_p, ks20_pp, n20, J20, ...
 kd20, ka20, ki20, Ja20, Ji20, kah1_p, kah1_pp, kih1_p, kih1a_pp, kih1b_pp, kih1d_pp, kih1e_pp, Jah1 ,Jih1 ,kawee_p, ...
 kawee_pp, kiwee_p, kiwee_pp, Jawee, Jiwee, ka25_p, ka25_pp, ki25_p, ki25_pp, Ja25, Ji25, KEZ,ks21_p ,ks21_pp ,kd21_p, ...
 kass21d, kass21e, kdiss21d, kdiss21e, ks25, kd25, Kp53b, Kp53a, ki25_ppp, ksh1, ksAPC, ...
 kswee, ksTFB, ksTFE, ksTFI, ksd, kdd] = deal_args(p);

% % ********************          ALGEBRAIC EQUATIONS          ********************
CHX = 1-CHX;
Cdc14 = Cdc20A;
Vsd = CHX*ksd*M*(1-Dko);
Vdd = kdd;
Vsb = CHX*(ksb_p+ksb_pp*TFB)*1.7/(1+arrest_III*p534np/Kp53b);
Vdb = kdb_p+kdbh_pp*Cdh1+kdbc_pp*Cdc20A;
Vsa = CHX*(ksa_p+ksa_pp*TFE)*1.7/(1+arrest_III*p534np/Kp53a);
Vda = kda_p+(kda_pp+kda_ppp)*Cdc20A+kda_ppp*Cdc20i;
Vse = CHX*(kse_p+kse_pp*TFE)*M*(1-Eko);
Vde = kde_p+kdee_pp*CycE+kdea_pp*CycA+kdeb_pp*CycB;
Vsi = CHX*(ksi_p+ksi_pp*TFI);
Vdi = (kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc14);
Vs20 = CHX*(ks20_p+ks20_pp*CycB^n20/(J20^n20+CycB^n20));
Vd20 = kd20;
Vsh1 = CHX*(ksh1);
Vdh1 = ksh1;
Vs21 = CHX*(ks21_p*p534np*arrest_I+ks21_pp*p53_basal);
Vd21 = kd21_p;
Vs25T = CHX*ks25;
Vd25T = kd25;
VsAPC = CHX*ksAPC;
VdAPC = ksAPC;
Vswee = CHX*kswee;
Vdwee = kswee;
VsTFB = CHX*ksTFB;
VdTFB = ksTFB;
VsTFE = CHX*ksTFE;
VdTFE = ksTFE;
VsTFI = CHX*ksTFI;
VdTFI = ksTFI;
Vwee = kwee_p+kwee_pp*Wee1;
Vatf = katf_p+katfa_pp*CycA+katfe_pp*CycE+katfd_pp*CycD;
Vitf = kitf_p+kitfa_pp*CycA+kitfb_pp*CycB;
V25 = k25_p+k25_pp*Cdc25;
Vah1 = kah1_p+kah1_pp*Cdc14;
Vih1 = kih1_p+kih1a_pp*CycA+kih1b_pp*CycB+kih1e_pp*CycE+kih1d_pp*CycD;
Va25 = ka25_p+ka25_pp*CycB;
Vi25 = ki25_p+ki25_pp*Cdc14+ki25_ppp*chk2p*arrest_II;
p21D = -kass21d*p21*CycD+kdiss21d*TriD21;
p21A = 0;
p21B = 0;
p21E = -kass21e*p21*CycE+kdiss21e*TriE21;

% % ********************          DIFFERENTIAL EQUATIONS          ********************
dxdt = [
        Vsd-Vdd*CycD+p21D+Vd21*TriD21;
        Vsa-Vda*CycA-kassa*CKI*CycA+kdissa*TriA+Vdi*TriA+p21A+Vd21*TriA21;
        Vsb-Vdb*CycB+V25*pB-Vwee*CycB-kassb*CycB*CKI+kdissb*BCKI+Vdi*BCKI+p21B+Vd21*TriB21;
        -Vdb*pB-V25*pB+Vwee*CycB-kassb*pB*CKI+kdissb*pBCKI+Vdi*pBCKI;
        Vse-Vde*CycE-kasse*CKI*CycE+kdisse*TriE+Vdi*TriE+p21E+Vd21*TriE21;
        VsAPC-VdAPC*APC-kaie*CycB*APC/(Jaie+APC)+kiie*APCP/(Jiie+APCP);
        -VdAPC*APCP+kaie*CycB*APC/(Jaie+APC)-kiie*APCP/(Jiie+APCP);
        Vsi-Vdi*CKI-kassb*CycB*CKI+kdissb*BCKI-kassb*pB*CKI+kdissb*pBCKI-kassa*CKI*CycA+kdissa*TriA-kasse*CKI*CycE+kdisse*TriE+Vdb*BCKI+Vdb*pBCKI+Vda*TriA+Vde*TriE;
        -Vdi*BCKI-Vdb*BCKI+kassb*CycB*CKI-kdissb*BCKI+V25*pBCKI-Vwee*BCKI;
        -Vdi*pBCKI-Vdb*pBCKI+kassb*pB*CKI-kdissb*pBCKI-V25*pBCKI+Vwee*BCKI;
        Vs20-Vd20*Cdc20i-ka20*APCP*Cdc20i/(Ja20+Cdc20i)+ki20*Cdc20A/(Ji20+Cdc20A);
        -Vd20*Cdc20A+ka20*APCP*Cdc20i/(Ja20+Cdc20i)-ki20*Cdc20A/(Ji20+Cdc20A);
        Vsh1-Vdh1*Cdh1+Vah1*Cdh1i/(Jah1+Cdh1i)-Vih1*Cdh1/(Jih1+Cdh1);
        -Vdh1*Cdh1i-Vah1*Cdh1i/(Jah1+Cdh1i)+Vih1*Cdh1/(Jih1+Cdh1);
        -Vdi*TriA+kassa*CKI*CycA-kdissa*TriA-Vda*TriA;
        -Vde*TriE+kasse*CKI*CycE-kdisse*TriE-Vdi*TriE;
        Vswee-Vdwee*Wee1+(kawee_p+kawee_pp*Cdc14)*Wee1i/(Jawee+Wee1i)-(kiwee_p+kiwee_pp*CycB)*Wee1/(Jiwee+Wee1);
        -Vdwee*Wee1i-(kawee_p+kawee_pp*Cdc14)*Wee1i/(Jawee+Wee1i)+(kiwee_p+kiwee_pp*CycB)*Wee1/(Jiwee+Wee1);
        Vs25T-Vd25T*Cdc25+Va25*Cdc25i/(Ja25+Cdc25i)-Vi25*Cdc25/(Ji25+Cdc25);
        -Vd25T*Cdc25i-Va25*Cdc25i/(Ja25+Cdc25i)+Vi25*Cdc25/(Ji25+Cdc25);
        -VdTFB*TFB+(kafb*CycB)*TFBi/(Jafb+TFBi)-kifb*TFB/(Jifb+TFB);
        VsTFB-VdTFB*TFBi-(kafb*CycB)*TFBi/(Jafb+TFBi)+kifb*TFB/(Jifb+TFB);
        VsTFE-VdTFE*TFE+Vatf*TFEi/(Jatf+TFEi)-Vitf*TFE/(Jitf+TFE);
        -VdTFE*TFEi-Vatf*TFEi/(Jatf+TFEi)+Vitf*TFE/(Jitf+TFE);
        -VdTFI*TFI+kafi*Cdc14*TFIi/(Jafi+TFIi)-(kifi_p+kifib_pp*CycB)*TFI/(Jifi+TFI);
        VsTFI-VdTFI*TFIi-kafi*Cdc14*TFIi/(Jafi+TFIi)+(kifi_p+kifib_pp*CycB)*TFI/(Jifi+TFI);
        Vs21-Vd21*p21+p21D+Vdd*TriD21+p21A+Vda*TriA21+p21B+Vdb*TriB21+p21E+Vde*TriE21;
        -Vd21*TriD21-p21D-Vdd*TriD21;
        -Vd21*TriA21-p21A-Vda*TriA21;
        -Vd21*TriB21-p21B-Vdb*TriB21;
        -Vd21*TriE21-p21E-Vde*TriE21;
	   ];
 end
function [Jx] = final_model_jacobian(t, x, p, u)

% Inputs (as described in Supplementary Table 1)
% 1     -   mitogen levels
% 2,3   -   DNA damage (modeled by p53 and chk2p activation)
% 4,5   -   cyclin D and E knockouts
% 6     -   cycloheximide treatment
% 7     -   p53 basal activation (0.75 for wild-type cells, 0 for p53-/- cells)
% 8-10  -   arrest mechanisms I-III

u = u(t);
[M, p534np, chk2p, Dko, Eko, CHX, p53_basal, arrest_I, arrest_II, arrest_III] = deal_args(u);

% All model species. Time derivatives are calculated for species in the order listed here.
[CycD, CycA, CycB, pB ,CycE, APC, APCP, CKI, BCKI, pBCKI, Cdc20i, Cdc20A, Cdh1, Cdh1i, TriA, TriE, Wee1, Wee1i, ...
 Cdc25, Cdc25i, TFB, TFBi, TFE, TFEi, TFI, TFIi, p21, TriD21, TriA21, TriB21, TriE21] = deal_args(x);

% All model parameters.
[kse_p, kse_pp, kde_p, kdea_pp, kdeb_pp, kdee_pp, kasse, kdisse, katf_p, katfa_pp, katfd_pp, katfe_pp, kitf_p, ...
 kitfa_pp, kitfb_pp, Jatf, Jitf , ~, ksb_pp, kdb_p, kdbh_pp, kdbc_pp, kassb, kdissb, kwee_p, kwee_pp, k25_p, ...
 k25_pp, kafb, kifb, Jafb, Jifb , ~, ksa_pp, kda_p, kda_pp, kda_ppp, kassa, kdissa, ksi_p, ksi_pp, kdi_p, kdia_pp, ...
 kdib_pp, kdid_pp, kdie_pp, k14di, kafi, kifi_p, kifib_pp, Jafi, Jifi, kaie, kiie, Jaie, Jiie, ks20_p, ks20_pp, n20, J20, ...
 kd20, ka20, ki20, Ja20, Ji20, kah1_p, kah1_pp, kih1_p, kih1a_pp, kih1b_pp, kih1d_pp, kih1e_pp, Jah1, Jih1, kawee_p, ...
 kawee_pp, kiwee_p, kiwee_pp, Jawee, Jiwee, ka25_p, ka25_pp, ki25_p, ki25_pp, Ja25, Ji25, KEZ, ks21_p, ks21_pp, kd21_p, ...
 kass21d, kass21e, kdiss21d, kdiss21e ks25, kd25, Kp53b, Kp53a, ki25_ppp, ksh1, ksAPC, ...
 kswee, ksTFB, ksTFE, ksTFI ksd, kdd] = deal_args(p);

% the Jacobian of the cell cycle model
Jx =   [
            -kdd-kass21d*p21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-kass21d*CycD,kdiss21d+kd21_p,0,0,0
            kdid_pp/(1+k14di*Cdc20A)*TriA,-kda_p-(kda_pp+kda_ppp)*Cdc20A-kda_ppp*Cdc20i-kassa*CKI+kdia_pp/(1+k14di*Cdc20A)*TriA,kdib_pp/(1+k14di*Cdc20A)*TriA,0,kdie_pp/(1+k14di*Cdc20A)*TriA,0,0,-kassa*CycA,0,0,-kda_ppp*CycA,-(kda_pp+kda_ppp)*CycA-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*TriA*k14di,0,0,kdissa+(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A),0,0,0,0,0,0,0,17/10*CHX*ksa_pp/(1+arrest_III*p534np/Kp53a),0,0,0,0,0,kd21_p,0,0
            kdid_pp/(1+k14di*Cdc20A)*BCKI,kdia_pp/(1+k14di*Cdc20A)*BCKI,-kdb_p-kdbh_pp*Cdh1-kdbc_pp*Cdc20A-kwee_p-kwee_pp*Wee1-kassb*CKI+kdib_pp/(1+k14di*Cdc20A)*BCKI,k25_p+k25_pp*Cdc25,kdie_pp/(1+k14di*Cdc20A)*BCKI,0,0,-kassb*CycB,kdissb+(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A),0,0,-kdbc_pp*CycB-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*BCKI*k14di,-kdbh_pp*CycB,0,0,0,-kwee_pp*CycB,0,k25_pp*pB,0,17/10*CHX*ksb_pp/(1+arrest_III*p534np/Kp53b),0,0,0,0,0,0,0,0,kd21_p,0
            kdid_pp/(1+k14di*Cdc20A)*pBCKI,kdia_pp/(1+k14di*Cdc20A)*pBCKI,kwee_p+kwee_pp*Wee1+kdib_pp/(1+k14di*Cdc20A)*pBCKI,-kdb_p-kdbh_pp*Cdh1-kdbc_pp*Cdc20A-k25_p-k25_pp*Cdc25-kassb*CKI,kdie_pp/(1+k14di*Cdc20A)*pBCKI,0,0,-kassb*pB,0,kdissb+(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A),0,-kdbc_pp*pB-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*pBCKI*k14di,-kdbh_pp*pB,0,0,0,kwee_pp*CycB,0,-k25_pp*pB,0,0,0,0,0,0,0,0,0,0,0,0
            kdid_pp/(1+k14di*Cdc20A)*TriE,-kdea_pp*CycE+kdia_pp/(1+k14di*Cdc20A)*TriE,-kdeb_pp*CycE+kdib_pp/(1+k14di*Cdc20A)*TriE,0,-2*kdee_pp*CycE-kde_p-kdea_pp*CycA-kdeb_pp*CycB-kasse*CKI+kdie_pp/(1+k14di*Cdc20A)*TriE-kass21e*p21,0,0,-kasse*CycE,0,0,0,-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*TriE*k14di,0,0,0,kdisse+(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A),0,0,0,0,0,0,CHX*kse_pp*M*(1-Eko),0,0,0,-kass21e*CycE,0,0,0,kdiss21e+kd21_p
            0,0,-kaie*APC/(Jaie+APC),0,0,-ksAPC-kaie*CycB/(Jaie+APC)+kaie*CycB*APC/(Jaie+APC)^2,kiie/(Jiie+APCP)-kiie*APCP/(Jiie+APCP)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,kaie*APC/(Jaie+APC),0,0,kaie*CycB/(Jaie+APC)-kaie*CycB*APC/(Jaie+APC)^2,-ksAPC-kiie/(Jiie+APCP)+kiie*APCP/(Jiie+APCP)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            -kdid_pp/(1+k14di*Cdc20A)*CKI,-kdia_pp/(1+k14di*Cdc20A)*CKI-kassa*CKI+kdea_pp*TriE,-kdib_pp/(1+k14di*Cdc20A)*CKI-kassb*CKI+kdeb_pp*TriE,-kassb*CKI,-kdie_pp/(1+k14di*Cdc20A)*CKI-kasse*CKI+kdee_pp*TriE,0,0,-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)-kassb*CycB-kassb*pB-kassa*CycA-kasse*CycE,kdissb+kdb_p+kdbh_pp*Cdh1+kdbc_pp*Cdc20A,kdissb+kdb_p+kdbh_pp*Cdh1+kdbc_pp*Cdc20A,kda_ppp*TriA,(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*CKI*k14di+kdbc_pp*BCKI+kdbc_pp*pBCKI+(kda_pp+kda_ppp)*TriA,kdbh_pp*BCKI+kdbh_pp*pBCKI,0,kdissa+kda_p+(kda_pp+kda_ppp)*Cdc20A+kda_ppp*Cdc20i,kdisse+kde_p+kdee_pp*CycE+kdea_pp*CycA+kdeb_pp*CycB,0,0,0,0,0,0,0,0,CHX*ksi_pp,0,0,0,0,0,0
            -kdid_pp/(1+k14di*Cdc20A)*BCKI,-kdia_pp/(1+k14di*Cdc20A)*BCKI,-kdib_pp/(1+k14di*Cdc20A)*BCKI+kassb*CKI,0,-kdie_pp/(1+k14di*Cdc20A)*BCKI,0,0,kassb*CycB,-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)-kdb_p-kdbh_pp*Cdh1-kdbc_pp*Cdc20A-kdissb-kwee_p-kwee_pp*Wee1,k25_p+k25_pp*Cdc25,0,(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*BCKI*k14di-kdbc_pp*BCKI,-kdbh_pp*BCKI,0,0,0,-kwee_pp*BCKI,0,k25_pp*pBCKI,0,0,0,0,0,0,0,0,0,0,0,0
            -kdid_pp/(1+k14di*Cdc20A)*pBCKI,-kdia_pp/(1+k14di*Cdc20A)*pBCKI,-kdib_pp/(1+k14di*Cdc20A)*pBCKI,kassb*CKI,-kdie_pp/(1+k14di*Cdc20A)*pBCKI,0,0,kassb*pB,kwee_p+kwee_pp*Wee1,-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)-kdb_p-kdbh_pp*Cdh1-kdbc_pp*Cdc20A-kdissb-k25_p-k25_pp*Cdc25,0,(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*pBCKI*k14di-kdbc_pp*pBCKI,-kdbh_pp*pBCKI,0,0,0,kwee_pp*BCKI,0,-k25_pp*pBCKI,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,CHX*(ks20_pp*CycB^n20*n20/CycB/(J20^n20+CycB^n20)-ks20_pp*(CycB^n20)^2/(J20^n20+CycB^n20)^2*n20/CycB),0,0,0,-ka20*Cdc20i/(Ja20+Cdc20i),0,0,0,-kd20-ka20*APCP/(Ja20+Cdc20i)+ka20*APCP*Cdc20i/(Ja20+Cdc20i)^2,ki20/(Ji20+Cdc20A)-ki20*Cdc20A/(Ji20+Cdc20A)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,0,0,0,0,ka20*Cdc20i/(Ja20+Cdc20i),0,0,0,ka20*APCP/(Ja20+Cdc20i)-ka20*APCP*Cdc20i/(Ja20+Cdc20i)^2,-kd20-ki20/(Ji20+Cdc20A)+ki20*Cdc20A/(Ji20+Cdc20A)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            -kih1d_pp*Cdh1/(Jih1+Cdh1),-kih1a_pp*Cdh1/(Jih1+Cdh1),-kih1b_pp*Cdh1/(Jih1+Cdh1),0,-kih1e_pp*Cdh1/(Jih1+Cdh1),0,0,0,0,0,0,kah1_pp*Cdh1i/(Jah1+Cdh1i),-ksh1-(kih1_p+kih1a_pp*CycA+kih1b_pp*CycB+kih1e_pp*CycE+kih1d_pp*CycD)/(Jih1+Cdh1)+(kih1_p+kih1a_pp*CycA+kih1b_pp*CycB+kih1e_pp*CycE+kih1d_pp*CycD)*Cdh1/(Jih1+Cdh1)^2,(kah1_p+kah1_pp*Cdc20A)/(Jah1+Cdh1i)-(kah1_p+kah1_pp*Cdc20A)*Cdh1i/(Jah1+Cdh1i)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            kih1d_pp*Cdh1/(Jih1+Cdh1),kih1a_pp*Cdh1/(Jih1+Cdh1),kih1b_pp*Cdh1/(Jih1+Cdh1),0,kih1e_pp*Cdh1/(Jih1+Cdh1),0,0,0,0,0,0,-kah1_pp*Cdh1i/(Jah1+Cdh1i),(kih1_p+kih1a_pp*CycA+kih1b_pp*CycB+kih1e_pp*CycE+kih1d_pp*CycD)/(Jih1+Cdh1)-(kih1_p+kih1a_pp*CycA+kih1b_pp*CycB+kih1e_pp*CycE+kih1d_pp*CycD)*Cdh1/(Jih1+Cdh1)^2,-ksh1-(kah1_p+kah1_pp*Cdc20A)/(Jah1+Cdh1i)+(kah1_p+kah1_pp*Cdc20A)*Cdh1i/(Jah1+Cdh1i)^2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            -kdid_pp/(1+k14di*Cdc20A)*TriA,-kdia_pp/(1+k14di*Cdc20A)*TriA+kassa*CKI,-kdib_pp/(1+k14di*Cdc20A)*TriA,0,-kdie_pp/(1+k14di*Cdc20A)*TriA,0,0,kassa*CycA,0,0,-kda_ppp*TriA,(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*TriA*k14di-(kda_pp+kda_ppp)*TriA,0,0,-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)-kdissa-kda_p-(kda_pp+kda_ppp)*Cdc20A-kda_ppp*Cdc20i,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            -kdid_pp/(1+k14di*Cdc20A)*TriE,-kdea_pp*TriE-kdia_pp/(1+k14di*Cdc20A)*TriE,-kdeb_pp*TriE-kdib_pp/(1+k14di*Cdc20A)*TriE,0,-kdee_pp*TriE+kasse*CKI-kdie_pp/(1+k14di*Cdc20A)*TriE,0,0,kasse*CycE,0,0,0,(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A)^2*TriE*k14di,0,0,0,-kde_p-kdee_pp*CycE-kdea_pp*CycA-kdeb_pp*CycB-kdisse-(kdi_p+kdia_pp*CycA+kdib_pp*CycB+kdie_pp*CycE+kdid_pp*CycD)/(1+k14di*Cdc20A),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,-kiwee_pp*Wee1/(Jiwee+Wee1),0,0,0,0,0,0,0,0,kawee_pp*Wee1i/(Jawee+Wee1i),0,0,0,0,-kswee-(kiwee_p+kiwee_pp*CycB)/(Jiwee+Wee1)+(kiwee_p+kiwee_pp*CycB)*Wee1/(Jiwee+Wee1)^2,(kawee_p+kawee_pp*Cdc20A)/(Jawee+Wee1i)-(kawee_p+kawee_pp*Cdc20A)*Wee1i/(Jawee+Wee1i)^2,0,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,kiwee_pp*Wee1/(Jiwee+Wee1),0,0,0,0,0,0,0,0,-kawee_pp*Wee1i/(Jawee+Wee1i),0,0,0,0,(kiwee_p+kiwee_pp*CycB)/(Jiwee+Wee1)-(kiwee_p+kiwee_pp*CycB)*Wee1/(Jiwee+Wee1)^2,-kswee-(kawee_p+kawee_pp*Cdc20A)/(Jawee+Wee1i)+(kawee_p+kawee_pp*Cdc20A)*Wee1i/(Jawee+Wee1i)^2,0,0,0,0,0,0,0,0,0,0,0,0,0
            0,0,ka25_pp*Cdc25i/(Ja25+Cdc25i),0,0,0,0,0,0,0,0,-ki25_pp*Cdc25/(Ji25+Cdc25),0,0,0,0,0,0,-kd25-(ki25_p+ki25_pp*Cdc20A+ki25_ppp*chk2p*arrest_II)/(Ji25+Cdc25)+(ki25_p+ki25_pp*Cdc20A+ki25_ppp*chk2p*arrest_II)*Cdc25/(Ji25+Cdc25)^2,(ka25_p+ka25_pp*CycB)/(Ja25+Cdc25i)-(ka25_p+ka25_pp*CycB)*Cdc25i/(Ja25+Cdc25i)^2,0,0,0,0,0,0,0,0,0,0,0
            0,0,-ka25_pp*Cdc25i/(Ja25+Cdc25i),0,0,0,0,0,0,0,0,ki25_pp*Cdc25/(Ji25+Cdc25),0,0,0,0,0,0,(ki25_p+ki25_pp*Cdc20A+ki25_ppp*chk2p*arrest_II)/(Ji25+Cdc25)-(ki25_p+ki25_pp*Cdc20A+ki25_ppp*chk2p*arrest_II)*Cdc25/(Ji25+Cdc25)^2,-kd25-(ka25_p+ka25_pp*CycB)/(Ja25+Cdc25i)+(ka25_p+ka25_pp*CycB)*Cdc25i/(Ja25+Cdc25i)^2,0,0,0,0,0,0,0,0,0,0,0
            0,0,kafb*TFBi/(Jafb+TFBi),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-ksTFB-kifb/(Jifb+TFB)+kifb*TFB/(Jifb+TFB)^2,kafb*CycB/(Jafb+TFBi)-kafb*CycB*TFBi/(Jafb+TFBi)^2,0,0,0,0,0,0,0,0,0
            0,0,-kafb*TFBi/(Jafb+TFBi),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,kifb/(Jifb+TFB)-kifb*TFB/(Jifb+TFB)^2,-ksTFB-kafb*CycB/(Jafb+TFBi)+kafb*CycB*TFBi/(Jafb+TFBi)^2,0,0,0,0,0,0,0,0,0
            katfd_pp*TFEi/(Jatf+TFEi),katfa_pp*TFEi/(Jatf+TFEi)-kitfa_pp*TFE/(Jitf+TFE),-kitfb_pp*TFE/(Jitf+TFE),0,katfe_pp*TFEi/(Jatf+TFEi),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-ksTFE-(kitf_p+kitfa_pp*CycA+kitfb_pp*CycB)/(Jitf+TFE)+(kitf_p+kitfa_pp*CycA+kitfb_pp*CycB)*TFE/(Jitf+TFE)^2,(katf_p+katfa_pp*CycA+katfe_pp*CycE+katfd_pp*CycD)/(Jatf+TFEi)-(katf_p+katfa_pp*CycA+katfe_pp*CycE+katfd_pp*CycD)*TFEi/(Jatf+TFEi)^2,0,0,0,0,0,0,0
            -katfd_pp*TFEi/(Jatf+TFEi),-katfa_pp*TFEi/(Jatf+TFEi)+kitfa_pp*TFE/(Jitf+TFE),kitfb_pp*TFE/(Jitf+TFE),0,-katfe_pp*TFEi/(Jatf+TFEi),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(kitf_p+kitfa_pp*CycA+kitfb_pp*CycB)/(Jitf+TFE)-(kitf_p+kitfa_pp*CycA+kitfb_pp*CycB)*TFE/(Jitf+TFE)^2,-ksTFE-(katf_p+katfa_pp*CycA+katfe_pp*CycE+katfd_pp*CycD)/(Jatf+TFEi)+(katf_p+katfa_pp*CycA+katfe_pp*CycE+katfd_pp*CycD)*TFEi/(Jatf+TFEi)^2,0,0,0,0,0,0,0
            0,0,-kifib_pp*TFI/(Jifi+TFI),0,0,0,0,0,0,0,0,kafi*TFIi/(Jafi+TFIi),0,0,0,0,0,0,0,0,0,0,0,0,-ksTFI-(kifi_p+kifib_pp*CycB)/(Jifi+TFI)+(kifi_p+kifib_pp*CycB)*TFI/(Jifi+TFI)^2,kafi*Cdc20A/(Jafi+TFIi)-kafi*Cdc20A*TFIi/(Jafi+TFIi)^2,0,0,0,0,0
            0,0,kifib_pp*TFI/(Jifi+TFI),0,0,0,0,0,0,0,0,-kafi*TFIi/(Jafi+TFIi),0,0,0,0,0,0,0,0,0,0,0,0,(kifi_p+kifib_pp*CycB)/(Jifi+TFI)-(kifi_p+kifib_pp*CycB)*TFI/(Jifi+TFI)^2,-ksTFI-kafi*Cdc20A/(Jafi+TFIi)+kafi*Cdc20A*TFIi/(Jafi+TFIi)^2,0,0,0,0,0
            -kass21d*p21,kdea_pp*TriE21,kdeb_pp*TriE21,0,-kass21e*p21+kdee_pp*TriE21,0,0,0,0,0,kda_ppp*TriA21,(kda_pp+kda_ppp)*TriA21+kdbc_pp*TriB21,kdbh_pp*TriB21,0,0,0,0,0,0,0,0,0,0,0,0,0,-kd21_p-kass21d*CycD-kass21e*CycE,kdiss21d+kdd,kda_p+(kda_pp+kda_ppp)*Cdc20A+kda_ppp*Cdc20i,kdb_p+kdbh_pp*Cdh1+kdbc_pp*Cdc20A,kdiss21e+kde_p+kdee_pp*CycE+kdea_pp*CycA+kdeb_pp*CycB
            kass21d*p21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,kass21d*CycD,-kd21_p-kdiss21d-kdd,0,0,0
            0,0,0,0,0,0,0,0,0,0,-kda_ppp*TriA21,-(kda_pp+kda_ppp)*TriA21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-kd21_p-kda_p-(kda_pp+kda_ppp)*Cdc20A-kda_ppp*Cdc20i,0,0
            0,0,0,0,0,0,0,0,0,0,0,-kdbc_pp*TriB21,-kdbh_pp*TriB21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-kd21_p-kdb_p-kdbh_pp*Cdh1-kdbc_pp*Cdc20A,0
            0,-kdea_pp*TriE21,-kdeb_pp*TriE21,0,kass21e*p21-kdee_pp*TriE21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,kass21e*CycE,0,0,0,-kd21_p-kdiss21e-kde_p-kdee_pp*CycE-kdea_pp*CycA-kdeb_pp*CycB
        ];
end
function [varargout] = deal_args(u, pad)
% function [a b c ...] = jdeal(v)
%
% A very simple function that deals the elements of a vector 'v' to
% individual outputs (a, b, c, ...). jdeal() implements this as the
% assignments:
%
% a = v(1), b = v(2), c = v(3), etc.

if nargin<3 || isempty(pad)
    pad = 0;
end

varargout = cell(nargout, 1);

for i = 1:length(u)
    varargout{i} = u(i);
end

% if pad = 1, additional output arguments will be set to zero
% if pad = 0, additional output arguments will be empty
if pad
    for i = length(u)+1:nargout
        varargout{i} = 0;
    end


end
end




