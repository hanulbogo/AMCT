#include "mex.h"
using namespace std;


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs!=5) mexErrMsgTxt("error :the input number error");

	 double *  weight= (double* )mxGetPr(prhs[0]);
	 int *  DPosr= (int* )mxGetPr(prhs[1]);
	 int *  DPosc= (int* )mxGetPr(prhs[2]);
	 int *  nsup= (int* )mxGetPr(prhs[3]);
	 int *  len= (int* )mxGetPr(prhs[4]);


	
 	plhs[0] = mxCreateDoubleMatrix( *nsup, *nsup, mxREAL );
	double * outlabel=(double *)mxGetPr(plhs[0]);

	for ( int j = 0; j <*len; j++ ){

		outlabel[DPosc[j]*(*nsup) +DPosr[j]] = weight[j];

	}
}