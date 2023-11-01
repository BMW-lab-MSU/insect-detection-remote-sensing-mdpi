//  GPL-3 License
// Copyright (c) 2019 Vincent Runge
#include <vector>

#ifndef DATA_H
#define DATA_H

///////////////////////////////////////////////////////////////
//// POINT STRUCTURE //// POINT STRUCTURE //// POINT STRUCTURE
///////////////////////////////////////////////////////////////
struct Point
{
  double y;
  double w;
};

////////////////////////////////////////////////
//// DATA CLASS //// DATA CLASS //// DATA CLASS
////////////////////////////////////////////////
class Data
{
  public:
    Data();
    ~Data();

    void copy(std::vector<double> vectData, std::vector<double> vectWeight, unsigned int nd, unsigned int nw);
    unsigned int getn() const;
    Point* getVecPt() const;

  private:
    Point* vecPt = NULL;
    unsigned int n; ///data length
};

#endif // DATA_H
