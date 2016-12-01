#include "mex.h"

const int NRSTATES = 31;
const int NRPARAMETERS = 109;
const int NRVARIABLES = 10;
const int NRREACTIONS = 41;
const int NREVENTS = 0;

const int hasOnlyNumericICs = 1;
double defaultICs_num[31] = {
	0.105714,0.383126,0.482762,0.120591,0.0529862,0.276228,0.723772,0.108,0,0,0.823144,0.230398,0.865504,0.134496,0.128534,0.0317192,0.00364798,0.996352,0.291542,0.845259,
	0.693664,0.306336,0.480227,0.519773,0.131029,0.868971,1.05e-12,4.86e-12,0,0,1.12e-12};
char *defaultICs_nonnum[1];

double defaultParam[109] = {
	0.0267291,0.072883,0.0125407,1.10534,0.983121,0.483203,38.8209,0.912304,0,0.944401,4.28962,0.695562,0.607466,0.142912,0.35565,0.0907949,0.0603596,0.111806,0.0708439,0.010781,
	1.31528,0.280204,0,0,0.458698,1.53115,0.0222803,3.9823,0.70991,0.621397,0.241342,0.536479,0,0.346922,0.255213,1.7602,0,19.4471,0.861202,1.27506,
	0,0.920235,3.61527,3.78353,0,3.75675,0,68.3042,68.3217,68.278,87.9837,88.0065,0.516847,0.569643,0.0125646,0.0395971,0,0.421152,0.998561,0.871955,
	0.225216,0.830418,0.716591,0.014172,0.00919189,0.489533,3.22698,0,0.405088,0.721552,0,0.277759,0.121344,0.0581422,0.186512,0,0,7.81986,0.298502,0.0724017,
	0,0.823676,1.47701,0,0.368602,0.373902,0.2,1.01271,0.00589595,0.138981,38.7428,38.7324,0.799988,0.659668,0.235923,0.207532,0.342914,0.420236,77.6484,0.19719,
	0.00284817,0.0406926,0.0165802,0.0275674,0.0186447,0.00838507,0.142774,10,50};
char *stateNames[31] = {
	"CycD","CycA","CycB","pB","CycE","APC","APCP","CKI","BCKI","pBCKI","Cdc20i","Cdc20A","Cdh1","Cdh1i","TriA","TriE","Wee1","Wee1i","Cdc25","Cdc25i",
	"TFB","TFBi","TFE","TFEi","TFI","TFIi","p21","TriD21","TriA21","TriB21","TriE21"};
char *parameterNames[109] = {
	"kse_p","kse_pp","kde_p","kdea_pp","kdeb_pp","kdee_pp","kasse","kdisse","katf_p","katfa_pp","katfd_pp","katfe_pp","kitf_p","kitfa_pp","kitfb_pp","Jatf","Jitf","ksb_p","ksb_pp","kdb_p",
	"kdbh_pp","kdbc_pp","kassb","kdissb","kwee_p","kwee_pp","k25_p","k25_pp","kafb","kifb","Jafb","Jifb","ksa_p","ksa_pp","kda_p","kda_pp","kda_ppp","kassa","kdissa","ksi_p",
	"ksi_pp","kdi_p","kdia_pp","kdib_pp","kdid_pp","kdie_pp","k14di","kafi","kifi_p","kifib_pp","Jafi","Jifi","kaie","kiie","Jaie","Jiie","ks20_p","ks20_pp","n20","J20",
	"kd20","ka20","ki20","Ja20","Ji20","kah1_p","kah1_pp","kih1_p","kih1a_pp","kih1b_pp","kih1d_pp","kih1e_pp","Jah1","Jih1","kawee_p","kawee_pp","kiwee_p","kiwee_pp","Jawee","Jiwee",
	"ka25_p","ka25_pp","ki25_p","ki25_pp","Ja25","Ji25","KEZ","ks21_p","ks21_pp","kd21_p","kass21d","kass21e","kdiss21d","kdiss21e","ks25","kd25","Kp53b","Kp53a","ki25_ppp","ksh1",
	"ksAPC","kswee","ksTFB","ksTFE","ksTFI","ksd","kdd","t_d","t_r"};
char *variableNames[10] = {
	"M","p534np","chk2p","Dko","Eko","CHX","p53_basal","arrest_I","arrest_II","arrest_III"};
char *variableFormulas[10] = {
	"1.8","0.0","0.0","0.0","0.0","1.0","0.75","1.0","1.0","1.0"};
char *reactionNames[41] = {
	"Cdc14","Vsd","Vdd","Vsb","Vdb","Vsa","Vda","Vse","Vde","Vsi","Vdi","Vs20","Vd20","Vsh1","Vdh1","Vs21","Vd21","Vs25T","Vd25T","VsAPC",
	"VdAPC","Vswee","Vdwee","VsTFB","VdTFB","VsTFE","VdTFE","VsTFI","VdTFI","Vwee","Vatf","Vitf","V25","Vah1","Vih1","Va25","Vi25","p21D","p21A","p21B",
	"p21E"};
char *eventNames[1];

void model(double time, double *stateVector, double *DDTvector, ParamData *paramdataPtr, int DOflag, double *variableVector, double *reactionVector, double *gout, int *eventVector);
void calc_ic_model(double *icVector, ParamData *paramdataPtr);

void CVODEmex25(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    CVODEmex25(nlhs, plhs, nrhs, prhs);
}
