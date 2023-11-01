/* main_mex.cpp 
    Main file for using gfpop in Matlab 
*/
#include <iostream>
#include <string>
#include "math.h"

#include"Omega.h"
#include"Cost.h"
#include"ExternFunctions.h"
#include"Data.h"
#include"Graph.h"
#include"Edge.h"
#include"Interval.h"
#include"Track.h"
#include"Piece.h"
#include"ListPiece.h"

#include "Cost.cpp"
#include "Data.cpp"
#include "Edge.cpp"
#include "ExternFunctions.cpp"
#include "Graph.cpp"
#include "Interval.cpp"
#include "ListPiece.cpp"
#include "Omega.cpp"
#include "Piece.cpp"
#include "Track.cpp"

#include "mex.hpp"
#include "mexAdapter.hpp"

using namespace matlab::data;
using namespace matlab::engine;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function{
    ArrayFactory factory;
    std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
    std::ostringstream stream;

public:
    void operator()(ArgumentList outputs, ArgumentList inputs){
        //checkArguments(outputs, inputs);

        // Input 

        // Data
        TypedArray<double> vectDataIn = std::move(inputs[0]);
        std::vector<double> vectData(vectDataIn.begin(),vectDataIn.end());
        
       // Graph
        StructArray mygraph(inputs[1]);
        Range<ForwardIterator,MATLABFieldIdentifier const> fields = mygraph.getFieldNames();
        TypedArray<double> state1In = mygraph[0][fields.begin()[0]];
        TypedArray<double> state2In = mygraph[0][fields.begin()[1]];
        TypedArray<MATLABString> edgeIn = mygraph[0][fields.begin()[2]];
        TypedArray<double> parameterIn = mygraph[0][fields.begin()[3]];
        TypedArray<double> penaltyIn = mygraph[0][fields.begin()[4]];
        TypedArray<double> KIn = mygraph[0][fields.begin()[5]];
        TypedArray<double> aIn = mygraph[0][fields.begin()[6]];
        TypedArray<double> minnIn = mygraph[0][fields.begin()[7]];
        TypedArray<double> maxxIn = mygraph[0][fields.begin()[8]];

                  ///9 variables in mygraph
        std::vector<int> state1(state1In.begin(),state1In.end());
    
        std::vector<int> state2(state2In.begin(),state2In.end());
    
        std::vector<std::string> typeEdge(edgeIn.begin(),edgeIn.end());
    
        std::vector<double> parameter(parameterIn.begin(),parameterIn.end());
    
        std::vector<double> penalty(penaltyIn.begin(),penaltyIn.end());
    
        std::vector<double> KK(KIn.begin(),KIn.end());
    
        std::vector<double> aa(aIn.begin(),aIn.end());
          
        std::vector<double> minn(minnIn.begin(),minnIn.end());
    
        std::vector<double> maxx(maxxIn.begin(),maxxIn.end());

        // Type
        TypedArray<MATLABString> typeIn = inputs[2];
        std::string type = std::string(typeIn[0]);

        // Vector Weights
        TypedArray<double> vectWeightIn = std::move(inputs[3]);
        std::vector<double> vectWeight(vectWeightIn.begin(),vectWeightIn.end());

        // Test Mode
        int testMode = std::move(inputs[4][0]);
        
        // Code from main.cpp for gfpop
                ///////////////////////////////////////////
          /////////// DATA TRANSFORMATION ///////////
          ///////////////////////////////////////////
          double epsilon = std::pow(10.0,-12.0);
       
          if(type == "variance")
          {
            double mean = 0;
            for(int i = 0; i < vectData.size(); i++){mean = mean + vectData[i];}
            mean = mean/vectData.size();
            for(int i = 0; i < vectData.size(); i++){vectData[i] = vectData[i] - mean; if(vectData[i] == 0){vectData[i] = epsilon;}}
          }
        
          if(type == "poisson")
          {
            for(int i = 0; i < vectData.size(); i++){if(vectData[i] < 0){throw std::range_error("There are some negative data");}}
            //for(int i = 0; i < vectData.size(); i++){if(vectData[i]  > floor(vectData[i])){throw std::range_error("There are some non-integer data");}}
          }
        
          if(type == "exp")
          {
            for(int i = 0; i < vectData.size(); i++){if(vectData[i] <= 0){throw std::range_error("Data has to be all positive");}}
          }
        
          if(type == "negbin")
          {
            unsigned int windowSize = 100;
            unsigned int k = vectData.size() / windowSize;
            double mean = 0;
            double variance = 0;
            double disp = 0;
        
            for(unsigned int j = 0; j < k; j++)
            {
              mean = 0;
              variance = 0;
              for(unsigned int i = j * windowSize; i < (j + 1)*windowSize; i++){mean = mean + vectData[i];}
              mean = mean/windowSize;
              for(unsigned int i =  j * windowSize; i < (j + 1)*windowSize; i++){variance = variance + (vectData[i] - mean) * (vectData[i] - mean);}
              variance = variance/(windowSize - 1);
              disp = disp  + (mean * mean / (variance - mean));
            }
            disp = disp/k;
            for(int i = 0; i < vectData.size(); i++){vectData[i] = vectData[i]/disp; if(vectData[i] == 0){vectData[i] = epsilon/(1- epsilon);}}
          }
        
          // BEGIN TRANSFERT into C++ objects  // BEGIN TRANSFERT into C++ objects  // BEGIN TRANSFERT into C++ objects
          // BEGIN TRANSFERT into C++ objects  // BEGIN TRANSFERT into C++ objects  // BEGIN TRANSFERT into C++ objects
          // DATA AND GRAPH
        
          /////////////////////////////////
          /////////// DATA COPY ///////////
          /////////////////////////////////

          Data data = Data();
          data.copy(vectData, vectWeight, vectData.size(), vectWeight.size());
        
          //////////////////////////////////
          /////////// GRAPH COPY ///////////
          //////////////////////////////////
        
          Graph graph = Graph();
          Edge newedge;

          for(int i = 0 ; i < state1.size(); i++){
              graph << Edge(state1[i], state2[i], typeEdge[i], fabs(parameter[i]), penalty[i], fabs(KK[i]), fabs(aa[i]), minn[i], maxx[i]);
          }

          if(testMode == 1){graph.show();} ///TESTMODE
        
          // END TRANSFERT into C++ objects  // END TRANSFERT into C++ objects  // END TRANSFERT into C++ objects
          // END TRANSFERT into C++ objects  // END TRANSFERT into C++ objects  // END TRANSFERT into C++ objects
        
          /////////////////////////////////////////////
          /////////// COST FUNCTION LOADING ///////////
          /////////////////////////////////////////////
        
          cost_coeff = coeff_factory(type);
          cost_eval = eval_factory(type);
        
          cost_min = min_factory(type);
          cost_minInterval = minInterval_factory(type);
          cost_argmin = argmin_factory(type);
          cost_argminInterval = argminInterval_factory(type);
          cost_argminBacktrack = argminBacktrack_factory(type);
        
          cost_shift = shift_factory(type);
          cost_interShift = interShift_factory(type);
          cost_expDecay = expDecay_factory(type);
          cost_interExpDecay = interExpDecay_factory(type);
        
          cost_intervalInterRoots = intervalInterRoots_factory(type);
          cost_age = age_factory(type);
          cost_interval = interval_factory(type);


          /////////////////////////////
          /////////// OMEGA ///////////
          /////////////////////////////
        
          Omega omega(graph);

          if(testMode == 0){
              omega.gfpop(data);
          }else{
              omega.gfpopTestMode(data);
          }

          /////////////////////////////
          /////////// RETURN //////////
          /////////////////////////////
        
        // Gathering Output Parameters into C++ Data
        std::vector<std::vector<int>> changepoints = omega.GetChangepoints();
        std::vector<std::vector<int>> states = omega.GetStates();
        std::vector<std::vector<bool>> forced = omega.GetForced();
        std::vector<std::vector<double>> parameters = omega.GetParameters();
        std::vector<double> globalCost = omega.GetGlobalCost();

        // Output Vector Creation
        StructArray res = factory.createStructArray({1,1},{"changepoints", "states", "forced", "parameters", "globalcost"});
        TypedArray<int> changepointsOut = factory.createArray({1,changepoints[0].size()},changepoints[0].data(),changepoints[0].data()+changepoints[0].size());
        TypedArray<int> statesOut = factory.createArray({1,states[0].size()},states[0].data(),states[0].data()+states[0].size());
        TypedArray<bool> forcedOut = factory.createArray({1,forced[0].size()},forced[0].begin(),forced[0].end());
        TypedArray<double> paramsOut = factory.createArray({1,parameters[0].size()},parameters[0].data(),parameters[0].data()+parameters[0].size());
        TypedArray<double> globalCostOut = factory.createArray({1,globalCost.size()}, globalCost.data(), globalCost.data()+globalCost.size());

        // Reversing Vectors to go Start -> Finish
        std::reverse(changepointsOut.begin(),changepointsOut.end());
        std::reverse(statesOut.begin(),statesOut.end());
        std::reverse(forcedOut.begin(),forcedOut.end());
        std::reverse(paramsOut.begin(),paramsOut.end());
        std::reverse(globalCostOut.begin(),globalCostOut.end());

        // Assigning to Struct
        res[0]["changepoints"] = changepointsOut;
        res[0]["states"] = statesOut;
        res[0]["forced"] = forcedOut;
        res[0]["parameters"] = paramsOut;
        res[0]["globalcost"] = globalCostOut;

        // Sending struct to output
        outputs[0] = res;

    }
    /*
    void checkArguments(ArgumentList outputs, ArgumentList inputs){
        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr getEngine();
        ArrayFactory factory;
        // Check first input

        // Check output
    }
    */

    // Printing stream to console
    void displayOnMATLAB(std::ostringstream& stream){
        matlabPtr -> feval(u"fprintf",0,std::vector<Array>({factory.createScalar(stream.str())}));
        stream.str("");
    }
    
};
