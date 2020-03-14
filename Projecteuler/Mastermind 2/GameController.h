/*
 * GameController.cpp 
 * GameController class used to define opponent behavior
 * Writter:  Cai Mingda
 * Date:     8 Nov, 2015
 */

#include <array>
#include <string>

using namespace std;

#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#define SLOT_NUM 4      // 4 numbers in one sequence
#define CHANCE_NUM 8    // 8 rounds to guess the correct number
#define COLOR_NUM 6     // 1 slot has 6 options to choose

class GameController
{
private:
    array<int, SLOT_NUM> result;
    void summaryReport();
public:
    short counter = 0;
    array<string, CHANCE_NUM> summary;
    void generateRnd();
    int checkResult(array<int, SLOT_NUM> slot);
    GameController();
};

#endif
