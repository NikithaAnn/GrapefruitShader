displacement orange_displace_2(float Km = 0.12;)
{

//---------------------Initialise a Displacement Shader-----------------
	vector NN = normalize(N);
	point PP = transform("shader",P);
//----------------------------------------------------------------------


//--------------------Skin Bump-----------------------------------------
	float skinmag =0;
	float freq = 1;
	float i;
	
	
	
	for(i=0;i<6;i+=1)
    {
		skinmag+=abs(float noise(PP*freq)-0.5)*2/freq*freq;
        freq*=3;
	}
	skinmag /= length(vtransform("object",NN));
	
	// 0.01 is the displacement attentuation value
	skinmag = -0.01 * skinmag;
//----------------------------------------------------------------------


//--------------------Pore Surface--------------------------------------

	float fuzz = 0.3;
	float mag=0;
	mag=mix(0,0.4,float noise(PP*85));
	float inSpot=smoothstep(0.3-fuzz,0.7+fuzz,mag);
	
	float disp= smoothstep(0,1.25,inSpot);
	float poremag= disp;
	
	poremag *= -0.1;
//----------------------------------------------------------------------


//------------------Turbulence Deformation------------------------------
//Listing 26.7
	float deform = 0;
	float turb_freq = 1;
    
    for(i=0;i<6;i+=1)
        {
		deform +=abs(float noise(PP*turb_freq)-0.5)*2/turb_freq;
        turb_freq *=2.1;
        deform /= length(vtransform("object",NN));
		}
	

	
	deform *= 0.2;
//----------------------------------------------------------------------


//--------------------------Stem----------------------------------------

	//--------stemmag is for the small circular dent--------------------
	float stemmag = 0;
	
	//We first find the position of the dent
	float position = smoothstep(0.01,0.04,t);
	
	//If it is in position, we will set the stemmag as 1
	stemmag = mix(0,1,position);
	
	stemmag *=0.1;
	
	//--------replace position to add in the main hole------------------
	position = smoothstep(0.008,0.0145,t);
	
	float stemmag1 = mix(0,1,position);
	stemmag1 *=2;
//----------------------------------------------------------------------

//--------------Spokes on Top-------------------------------------------
	
	//First divide the s circularly around the z 
    float ss1=mod(s*7,1);
    //Divide the object along t to create a dented surface
    float tt1=mod((t)*2,1);
    
    float depression=0;
    point centre=point (0.5,0.5,0);
    point here=point (ss1,tt1,0);
    float dist=distance(centre,here);
    
    float inDisk= 1-smoothstep(-0.1,0.55+0.2*(noise(PP*25)),dist);

    //Checking if there is a depression
    //depression = inDisk;

    
    depression = mix(0,-1,inDisk);
    depression *= -0.5;
    

	PP = P+(depression)*Km*NN;
	N = calculatenormal(PP);


//----------------------------------------------------------------------

   
	mag = skinmag + poremag;
	//+ poremag+deform +stemmag + stemmag1+ depression;

	
//---------------Recalculation of normals and points--------------------
	//P = P+(mag)*Km*NN;
	//N=calculatenormal(P);
}
