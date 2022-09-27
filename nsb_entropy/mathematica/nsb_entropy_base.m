(* ::Package:: *)

(*: Name: NSBEntropy *)

(*: Author: Christian B. Mendl, (c) 2009-2011 *)

(*: Summary:
	Implementation of the NSB entropy estimation algorithm 
	References:
		Ilya Nemenman, Fariel Shafee, and William Bialek: "Entropy and Inference, Revisited" (2002) http://arxiv.org/abs/physics/0108025
		Ilya Nemenman: "Inference of entropies of discrete random variables with unknown cardinalities" (2002) http://arxiv.org/abs/physics/0207009 *)

BeginPackage["NSBEntropy`"]


\[Xi][\[Beta]_,K_]:=PolyGamma[K \[Beta]+1]-PolyGamma[\[Beta]+1]
d\[Xi][\[Beta]_,K_]:=K PolyGamma[1,1+K \[Beta]]-PolyGamma[1,1+\[Beta]]

(* original definition *)
(*\[Rho][\[Beta]_,nx_,kx_]:=Module[{\[Kappa]=Total[kx]\[Beta],M=kx.nx},Times@@((Pochhammer[\[Beta],#]&/@nx)^kx)/Pochhammer[\[Kappa],M]]*)
\[Rho]Log[\[Beta]_,nx_,kx_]:=Module[{K=Total[kx],\[Kappa],M=kx.nx},\[Kappa]=K \[Beta];-kx.LogGamma[nx+\[Beta]]+K LogGamma[\[Beta]]-LogGamma[\[Kappa]]+LogGamma[M+\[Kappa]]]
(* shift by L0 to avoid numerical overflow *)
\[Rho][\[Beta]_,nx_,kx_,L0_]:=Exp[-\[Rho]Log[\[Beta],nx,kx]+L0]

(* a posteriori entropy for Dirichlet prior *)
S1[\[Beta]_,nx_,kx_]:=Module[{\[Kappa]=Total[kx]\[Beta],M=kx.nx,p},
	p=PolyGamma[M+\[Kappa]+1];
	-(kx.((#+\[Beta])/(M+\[Kappa])(PolyGamma[#+\[Beta]+1]-p)&/@nx))];

(* entropy squared *)
S2[\[Beta]_,nx_,kx_]:=Module[{\[Kappa]=Total[kx]\[Beta],M=kx.nx,p,d,v},
	p=PolyGamma[M+\[Kappa]+2];
	d=(#+\[Beta])((#+\[Beta]+1)((PolyGamma[#+\[Beta]+2]-p)^2+PolyGamma[1,#+\[Beta]+2])-(*compensate for i!=j *)(#+\[Beta])(PolyGamma[#+\[Beta]+1]-p)^2)&/@nx;
	v=(#+\[Beta])(PolyGamma[#+\[Beta]+1]-p)&/@nx;
	(kx.d+(kx.v)^2)/((M+\[Kappa])(M+\[Kappa]+1))-PolyGamma[1,M+\[Kappa]+2]]

InferenceNSB[F_,nx_,kx_]:=Module[{K=Total[kx],M=kx.nx,K1,L0},K1=K-If[First[nx]==0,First[kx],0];
	(* estimate extremum of Log[\[Rho]] *)
	L0=\[Rho]Log[\[Kappa]/K/.FindRoot[K1/\[Kappa]+PolyGamma[\[Kappa]]-PolyGamma[M+\[Kappa]],{\[Kappa],1}],nx,kx];
	NIntegrate[\[Rho][\[Beta],nx,kx,L0]F[\[Beta],nx,kx]d\[Xi][\[Beta],K] (2\[Omega])/(1-\[Omega])^3/.\[Beta]->(\[Omega]/(1-\[Omega]))^2,{\[Omega],0,1},WorkingPrecision -> 60]/
		NIntegrate[\[Rho][\[Beta],nx,kx,L0]d\[Xi][\[Beta],K] (2\[Omega])/(1-\[Omega])^3/.\[Beta]->(\[Omega]/(1-\[Omega]))^2,{\[Omega],0,1},WorkingPrecision -> 60]]

EntropyNSB[nx_,kx_]:=InferenceNSB[S1,nx,kx]
EntropyNSB[n_]:=Module[{nx=Union[n],kx},kx=Count[n,#]&/@nx;EntropyNSB[nx,kx]]

DeltaEntropyNSB[nx_,kx_]:=Sqrt[InferenceNSB[S2,nx,kx]-InferenceNSB[S1,nx,kx]^2]
DeltaEntropyNSB[n_]:=Module[{nx=Union[n],kx},kx=Count[n,#]&/@nx;DeltaEntropyNSB[nx,kx]]


EndPackage[]
